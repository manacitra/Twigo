require 'http'

module RefEm
  module Gateway
    # Infrastructure to call RefEm API
    class Api
      def initialize(config)
        @config = config
        @request = Request.new(@config)
      end

      def alive?
        @request.get_root.success?
      end

      def papers_list(searchType, keyword)
        @request.papers_list(searchType, keyword)
      end

      def paper_content(id)
        @request.paper_content(id)
      end

      # HTTP request transmitter
      class Request
        def initialize(config)
          @api_host = config.API_HOST
          @api_root = config.API_HOST + 'api/v1'
        end

        def get_root
          call_api('get')
        end

        def papers_list(searchType, keyword)
          call_api('get', ['paper', searchType, keyword])
        end

        def paper_content(id)
          call_api('get', ['paper', id])
        end

        private

        def params_str(params)
          params.map{ |key, value| "#{key}=#{value}" }.join('&')
                .yield_self { |str| str ? '?' + str : ''}
        end

        def call_api(method, resources = [], params = {})
          api_path = resources.empty? ? @api_host : @api_root
          url = [api_path, resources].flatten.join('/') + params_str(params)
          HTTP.headers('Accept' => 'application/json').send(method, url)
              .yield_self { |http_response| Response.new(http_response) }
        rescue StandardError
          raise "invalid URL request: #{url}"
        end
      end

      # Decorates HTTP responses with success/error
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        SUCCESS_STATUS = (200..299).freeze

        def success?
          SUCCESS_STATUS.include? code
        end

        def message
          payload(message)
        end

        def payload
          body.to_s
        end
      end
    end
  end
end
