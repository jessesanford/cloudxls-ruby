require 'csv'

module CloudXLS
  DATETIME_FORMAT = "%FT%T.%L%z".freeze
  DATE_FORMAT = "%F".freeze

  # Wrapper around stdlib CSV methods.
  #
  class CSV
    def self.generate_line(arr, options = nil)
      ::CSV.generate_line(arr.as_csv, options)
    end
  end


  class CSVWriter
    # Generates CSV string.
    #
    # @param [Enumerable] scope
    #   Method/attribute keys to for the export.
    #
    # @option opts [String] :encoding ("UTF-8")
    #    Charset encoding of output.
    #
    # @option opts [Boolean] :skip_headers (false)
    #    Do not output headers if first element is an ActiveRecord object.
    #
    # @option opts [Array]   :only     same as #as_json
    # @option opts [Array]   :except   same as #as_json
    # @option opts [Array]   :methods  same as #as_json
    #
    # @return [String]
    #   The full CSV as a string. Titleizes *columns* for the header.
    #
    def self.text(scope, opts = {})
      encoding     = opts.delete(:encoding)     || "UTF-8"
      skip_headers = opts.delete(:skip_headers) || false

      str = ::CSV.generate(:encoding => encoding) do |csv|

        enum_method = scope_enumerator(scope)
        scope.send(enum_method) do |record|

          if skip_headers == false && !record.is_a?(Array)
            titles = CloudXLS::Util.titles_for_serialize_options(record, opts)
            csv << titles.map(&:titleize)
            skip_headers = true
          end

          csv << record.as_csv(opts)
        end
      end
      str.strip!
      str
    end


    # Generates Enumerator for streaming response.
    #
    # Example
    #
    #     def index
    #       # setup headers...
    #       stream = CloudXLS::CSVWriter.csv_enumerator(Post.all, only: [:title, :author])
    #       self.response_body = stream
    #     end
    #
    # Same options and parameters as #text.
    #
    # @return [Enumerator] enumerator to use for streaming response.
    #
    def self.enumerator(scope, options = {})
      encoding     = options.delete(:encoding)     || "UTF-8"
      skip_headers = options.delete(:skip_headers) || false

      Enumerator.new do |stream|
        enum_method = scope_enumerator(scope)

        scope.send(enum_method) do |record|
          if !skip_headers && !record.is_a?(Array)
            titles = CloudXLS::Util.titles_for_serialize_options(record, options)
            stream << titles.map(&:titleize).to_csv
            skip_headers = true
          end

          stream << record.as_csv(options).to_csv
        end
      end
    end


    def self.scope_enumerator(scope)
      if scope.respond_to?(:arel) &&
         scope.arel.orders.blank? &&
         scope.arel.taken.blank?
        :find_each
      else
        :each
      end
    end
  end
end

module CloudXLS
  class Util
    # Column and method-names of a model that correspond to the values from
    # a #as_json/#as_csv call. In the same order.
    #
    # Example
    #
    #     CloudXLS::Util.titles_for_serialize_options(Post.new, only: [:author, :title], method: [:slug])
    #     # => ['title', 'author', 'slug']
    #
    def self.titles_for_serialize_options(record, options = {})
      attribute_names = record.attributes.keys
      if only = options[:only]
        arr = []
        Array(only).map(&:to_s).each do |key|
          arr.push(key) if attribute_names.include?(key)
        end
        attribute_names = arr
      elsif except = options[:except]
        attribute_names -= Array(except).map(&:to_s)
      end

      Array(options[:methods]).each do |m|
        m = m.to_s
        if record.respond_to?(m)
          unless attribute_names.include?(m)
            attribute_names.push(val)
          end
        end
      end
      attribute_names
    end
  end
end
