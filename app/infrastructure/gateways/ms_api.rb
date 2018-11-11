# frozen_string_literal: true

require 'net/http'
require 'yaml'
require 'json'
# Load data parsing class
# require_relative 'paper_info.rb'

# Namespace for entire library
module RefEm
  # Library for Microsoft Academic Web API; Web API class
  module MSPaper
    # Library for Microsoft Academic Search API
    class Api
      def initialize(token)
        @ms_token = token
      end

      def paper_data(keywords, count)
        paper_response = Request.new(@ms_token)
                                .paper_info(keywords, count)
        # process data 
        res_data = JSON.parse(paper_response.body)
        # puts res_data
        res_data['entities'].map { |data|
          # puts data
          author_array = []
          field_array = []	
          reference_array = []	
          data['AA'].map { |author|
            author_array.push(author['AuN'])
          }
          data['AA'] = author_array

          data['F'].map { |field|
            field_array.push(field['FN'])
          }
          data['F'] = field_array

          if (!data['RId'].nil?)
            data['RId'].map { |rid|
              reference_array.push(rid.to_s)
            }
          end
          data['RId'] = reference_array

          data['E'] = JSON.parse(data['E'])
        }
        res_data['entities']
      end

      def reference_data(ref_id)
        # puts "!-----------------"
        # puts ref_id
        paper_response = Request.new(@ms_token)
                                .reference_info(ref_id)
        # process data 
        res_data = JSON.parse(paper_response.body)
        res_data['entities'].map { |data|
          # puts "response data:"
          # puts data
          author_array = []
          field_array = []	
          reference_array = []	
          data['AA'].map { |author|
            author_array.push(author['AuN'])
          }
          data['AA'] = author_array

          data['F'].map { |field|
            field_array.push(field['FN'])
          }
          data['F'] = field_array

          if (!data['RId'].nil?)
            data['RId'].map { |rid|
              reference_array.push(rid.to_s)
            }
          end
          data['RId'] = reference_array

          data['E'] = JSON.parse(data['E'])
        }
        res_data['entities']
      end      

      # send out HTTP requests to Github
      class Request
        # Initialize API library with token and cache object
        def initialize(token, cache: {})
          @token = token
          @cache = cache
        end

        def paper_info(keywords, count)
          uri = URI('https://api.labs.cognitive.microsoft.com/academic/v1.0/evaluate')
          query = URI.encode_www_form({
            # Request parameters
            'expr' => "W == '#{keywords}'",
            'model' => 'latest',
            'count' => "#{count}",
            'offset' => '0',
            'attributes' => 'Id,Ti,AA.AuN,Y,D,F.FN,E,RId'
          })

          if uri.query && uri.query.length > 0
            uri.query += '&' + query
          else
            uri.query = query
          end

          get(uri)
        end

        def reference_info(ref_id)
          uri = URI('https://api.labs.cognitive.microsoft.com/academic/v1.0/evaluate')
          query = URI.encode_www_form({
            # Request parameters
            'expr' => "Id = #{ref_id}",
            'model' => 'latest',
            'count' => '1',
            'offset' => '0',
            'attributes' => 'Id,Ti,AA.AuN,Y,D,F.FN,E,RId'
          })

          if uri.query && uri.query.length > 0
            uri.query += '&' + query
          else
            uri.query = query
          end
          # puts uri
          get(uri)
        end

        def get(uri)
          http_request = Net::HTTP::Get.new(uri.request_uri)
          # Request headers
          http_request['Ocp-Apim-Subscription-Key'] = @token
          # Request body
          http_response = @cache.fetch(uri) do
            response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
              http.request(http_request)
            end
          end

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end

      # Decorates HTTP responses from microsoft academic search with success/error
      class Response < SimpleDelegator
        Unauthorized = Class.new(StandardError)
        BadRequest = Class.new(StandardError)

        HTTP_ERROR = {
          '401' => Unauthorized,
          '400' => BadRequest
        }.freeze

        def successful?
          HTTP_ERROR.keys.include?(code) ? false : true
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
