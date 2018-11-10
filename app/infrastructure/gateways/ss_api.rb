# frozen_string_literal: true

require 'http'
# Namespace for entire library
module RefEm
  # Library for Semantic Scholar  API
  module SSPaper
    # Library for Semantic Scholar Search API
    class Api
      def initialize
      end

      def paper_data(doi)
        Request.new.ss_paper_data(doi).parse
      end

      class Request
        LOOKUP_PATH = 'http://api.semanticscholar.org/v1/paper/'.freeze
        
        def initialize
        end

        def ss_paper_data(doi)
          get(LOOKUP_PATH + doi)
        end

        def get(url)
          http_response = HTTP.headers(
            'Accept' => 'application/json'
          ).get(url)

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end

      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)

        HTTP_ERROR = {
          404 => NotFound
        }.freeze
        
        def successful?
          HTTP_ERROR.keys.include?(code) ? false : true
        end

        def error
          HTTP[code]
        end
      end
    end
  end
end
