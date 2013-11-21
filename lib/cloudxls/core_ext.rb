# Object#as_csv ensures that object formats are written the same across ruby
# versions.
#
# If an object is known to have issues cross-platform #as_json returns the
# desired string.
#
# Example:
#
#      DateTime.now.as_csv # => "2012-12-24T12:30:01.000+0000"
#      5.as_csv            # => 5
#      (0.0/0.0).as_csv    # => "#DIV/0!"
#

class Time
  def as_csv(options = nil)
    strftime(CloudXLS::DATETIME_FORMAT)
  end
end

class DateTime
  def as_csv(options = nil)
    strftime(CloudXLS::DATETIME_FORMAT)
  end
end

class String
  def as_csv(options = nil)
    self
  end
end

class Date
  def as_csv(options = nil)
    strftime(CloudXLS::DATE_FORMAT)
  end
end

class NilClass
  def as_csv(options = nil)
    nil
  end
end

class FalseClass
  def as_csv(options = nil)
    false
  end
end

class TrueClass
  def as_csv(options = nil)
    true
  end
end

class Symbol
  def as_csv(options = nil)
    to_s
  end
end

class Numeric
  def as_csv(options = nil)
    self
  end
end

class Float
  # Encoding Infinity or NaN to JSON should return "null". The default returns
  # "Infinity" or "NaN" which breaks parsing the JSON. E.g. JSON.parse('[NaN]').
  def as_csv(options = nil) #:nodoc:
    finite? ? self : "#DIV/0!"
  end
end

class Regexp
  def as_csv(options = nil)
    to_s
  end
end

module Enumerable
  def as_csv(options = nil)
    to_a.as_json(options)
  end
end

class Range
  def as_csv(options = nil)
    to_s
  end
end

class Array
  def as_csv(options = nil)
    map do |val|
      val.as_csv(options)
    end
  end
end

class Object
  def as_csv(options = nil)
    to_s
  end
end