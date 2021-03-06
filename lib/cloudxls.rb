require 'cgi'
require 'set'
require 'openssl'
require 'json'
require 'date'
require 'rest_client'
require 'json'

require_relative 'cloudxls/version'

class CloudXLS
  @https = true
  @api_base = 'api.cloudxls.com'.freeze
  @api_key  = ENV["CLOUDXLS_API_KEY"]

  class << self
    attr_accessor :api_key, :api_base, :api_version, :https
  end

  def self.api_url(path = '')
    # @api_base + url
    "http#{@https ? 's' : ''}://#{@api_key}:@#{@api_base}/v1/#{path}"
  end


  class CloudXLSResponse
    attr_reader :url, :uuid, :response

    def initialize(response)
      data = CloudXLS.parse_response(response)
      @response = response
      @url  = data['url']
      @uuid = data['uuid']
    end
  end


  def self.async(params = {})
    if params["mode"]
      params["mode"] = "async"
    else
      params[:mode] = "async"
    end
    CloudXLSResponse.new(convert(params))
  end


  def self.inline(params = {})
    if params["mode"]
      params["mode"] = "inline"
    else
      params[:mode] = "inline"
    end
    convert(params)
  end


  # @example
  #     CloudXLS.convert :data => {:file => File.new('/path/to/data.csv', 'r')}
  #     CloudXLS.convert :data => {:file => File.new("foo,bar\nlorem,ipsum")  }
  #     CloudXLS.convert :data => {:url => "https://example.com/data.csv"}
  #     CloudXLS.convert :data => {:url => "https://username:password@example.com/data.csv"}
  #
  def self.convert(params = {})
    check_api_key!

    headers = {}

    response = execute_request do
      RestClient.post(api_url("convert"), params, headers)
    end

    response
  end

  # @deprecated
  def self.xpipe(params = {})
    convert(params)
  end

  def self.execute_request
    begin
      return yield
    rescue SocketError => e
      handle_restclient_error(e)
    rescue NoMethodError => e
      # Work around RestClient bug
      if e.message =~ /\WRequestFailed\W/
        e = APIConnectionError.new('Unexpected HTTP response code')
        handle_restclient_error(e)
      else
        raise
      end
    rescue RestClient::ExceptionWithResponse => e
      if rcode = e.http_code and rbody = e.http_body
        # TODO
        # handle_api_error(rcode, rbody)
        handle_restclient_error(e)
      else
        handle_restclient_error(e)
      end
    rescue RestClient::Exception, Errno::ECONNREFUSED => e
      handle_restclient_error(e)
    end
  end

  def self.parse_response(response)
    json = JSON.parse(response.body)
  rescue => e
    raise general_api_error(response.code, response.body)
  end

  def self.general_api_error(rcode, rbody)
    StandardError.new("Invalid response object from API: #{rbody.inspect} " +
                 "(HTTP response code was #{rcode})" ) #, rcode, rbody)
  end



private
  def self.handle_restclient_error(e)
    case e
    when RestClient::ServerBrokeConnection, RestClient::RequestTimeout
      message = "Could not connect to CloudXLS (#{@api_base}). " +
        "Please check your internet connection and try again. "
    when RestClient::SSLCertificateNotVerified
      message = "Could not verify CloudXLS's SSL certificate. " +
        "Please make sure that your network is not intercepting certificates. "
    when SocketError
      message = "Unexpected error communicating when trying to connect to CloudXLS. " +
        "You may be seeing this message because your DNS is not working. " +
        "To check, try running 'host cloudxls.com' from the command line."
    else
      message = "Unexpected error communicating with CloudXLS. " +
        "If this problem persists, let us know at support@cloudxls.com."
    end

    raise StandardError.new(message + "\n\n(Network error: #{e.message})")
  end

  def self.check_api_key!
    unless api_key ||= @api_key
      raise StandardError.new('No API key provided. Set your API key using "CloudXLS.api_key = <API-KEY>". ')
    end

    if api_key =~ /\s/
      raise StandardError.new('Your API key is invalid, as it contains whitespace.')
    end
  end

end