
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

    if Endeca.analyze?
      def perform
        raise RequestError, endeca_error[:message] if endeca_error?
        Endeca.increase_metric(:request_count, 1)
        return response
      end
    else
      def perform
        raise RequestError, endeca_error[:message] if endeca_error?
        return response
      end
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

    if Endeca.analyze?
      def get_response #:nodoc:
         Endeca.log "ENDECA ADAPTER REQUEST"
         Endeca.log "    parameters => " + @query.inspect
         Endeca.log "           uri => " + uri.to_s
         Endeca.bm(:request_time, "#{@path} #{@query.inspect}") do 
           begin
             @response = Curl::Easy.perform(uri.to_s) do |curl|
               curl.timeout = Endeca.timeout
             end
           rescue => e
             raise RequestError, e.message
           end
         end

         return @response
       end
    else
      def get_response #:nodoc:
        Curl::Easy.perform(uri.to_s) do |curl|
          curl.timeout = Endeca.timeout
        end
      rescue => e
        raise RequestError, e.message
      end
    end
    
    if Endeca.analyze?
    
      def handle_response(response) #:nodoc:
        case response.response_code.to_s
        when "200"
          Endeca.bm :parse_time do
            begin
              Yajl::Parser.parse(response.body_str)
            rescue Yajl::ParseError => e
              raise RequestError, "JSON Parse error: #{e}"
            end
          end
        else
          raise RequestError, "#{response.response_code} HTTP Error"
        end
      end
    else
      def handle_response(response) #:nodoc:
        case response.response_code.to_s
        when "200"
          begin
            Yajl::Parser.parse(response.body_str)
          rescue Yajl::ParseError => e
            raise RequestError, "JSON Parse error: #{e}"
          end
        else
          raise RequestError, "#{response.response_code} HTTP Error"
        end
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
