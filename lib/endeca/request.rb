
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
      raise RequestError, endeca_error[:message] if endeca_error?
      Endeca.increase_metric(:request_count, 1) if Endeca.benchmark?
      return response
    end

    def response
      @response ||= handle_response(get_response)
    end

    def uri
      return @uri if @uri

      path_query = query_string
      @uri = path_query ? "#{@path}?#{path_query}" : @path
    end

    private

    def endeca_error
      method_response = response["methodResponse"]
      fault = method_response && method_response["fault"]
      values = fault && fault["value"]
      return nil unless values
      {
        :code => values["faultCode"].to_i,
        :message => values["faultString"]
      }
    end

    def endeca_error?
      !endeca_error.nil?
    end

    def get_response #:nodoc:
      if Endeca.debug?
        Endeca.log "ENDECA ADAPTER REQUEST"
        Endeca.log "    parameters => " + @query.inspect
        Endeca.log "           uri => " + uri.to_s
      end
      begin
        if Endeca.benchmark?
          Endeca.bm(:request_time, "#{@path} #{@query.inspect}") do 
            Curl::Easy.perform(uri.to_s) do |curl|
              curl.timeout = Endeca.timeout
            end
          end
        else
          Curl::Easy.perform(uri.to_s) do |curl|
            curl.timeout = Endeca.timeout
          end
        end
      rescue => e
        raise RequestError, e.message
      end
    end

    def handle_response(response) #:nodoc:
      begin
        case response.response_code.to_s
        when "200"
          if Endeca.benchmark?
            Endeca.bm :parse_time do
              Yajl::Parser.parse(response.body_str)
            end
          else
            Yajl::Parser.parse(response.body_str)
          end
        else
          raise RequestError, "#{response.response_code} HTTP Error"
        end
      rescue Yajl::ParseError => e
        raise RequestError, "JSON Parse error: #{e}"
      end
    end
    def query_string
      @path.match(/\?(.*)$/)
      query_string_parts = [$1, @query.to_endeca_params]
      query_string_parts.reject!{ |s| s.nil? || s.empty? }

      query_string_parts.empty? ? nil : query_string_parts.join('&')
    end
  end
end
