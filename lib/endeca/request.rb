require 'uri'
module Endeca
  class RequestError < ::StandardError; end

  class Request

    def self.perform(path, query=nil)
      raise RequestError, "Must provide a path" unless path
      new(path, query).perform
    end

    def initialize(path, query=nil)
      @path  = path.strip
      @query = query
    end

    def perform
      handle_response(get_response)
    end

    def uri
      return @uri if @uri

      @uri = URI.parse(@path)
      @uri.query = query_string
      @uri
    end

    private

    def get_response #:nodoc:
      Endeca.log "ENDECA ADAPTER REQUEST"
      Endeca.log "    parameters => " + @query.inspect
      Endeca.log "           uri => " + uri.to_s
      Endeca.bm  "  request time => " do @response = Net::HTTP.get_response(uri) end

      return @response
    end

    # Raises exception Net::XXX (http error code) if an http error occured
    def handle_response(response) #:nodoc:
      case response
      when Net::HTTPSuccess
        JSON.parse(response.body)
      else
        response.error! # raises exception corresponding to http error Net::XXX
      end

    rescue => e
      raise RequestError, e.message
    end

    def query_string
      query_string_parts = [@uri.query, @query.to_endeca_params]
      query_string_parts.reject!{ |s| s.nil? || s.empty? }

      query_string_parts.empty? ? nil : query_string_parts.join('&')
    end
  end
end
