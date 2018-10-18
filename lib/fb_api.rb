require 'httparty'
# Load data parsing class
require_relative 'place_checkins.rb'

# Namespace for entire library
module FacebookPlaces
  # Library for Facebook Web API; Web API class
  class FacebookAPI
    # Define our own errors
    module Errors
      class Nilclass < Nilclass; end
      class Unauthorized < StandardError; end
    end
    # Map HTTP codes to classes
    HTTP_ERROR = {
      401 => Errors::Unauthorized,
      204 => Errors::Nilclass
    }.freeze

    # Initialize API library with token and cache object
    def initialize(token, cache: {})
      @fb_token = token
      @cache = cache
    end

    def place_checkin(keywords, longitude, latitude, distance)
      checkin_req_url = fb_api_path(keywords, longitude, latitude, distance)
      checkin_data = call_fb_url(checkin_req_url)
      PlaceCheckin.new(checkin_data, self)
    end

    private

    def fb_api_path(keywords,longitude, latitude, distance)
      "https://graph.facebook.com/v3.1/search\
      ?type=place\
      &fields=name,checkins,picture\
      &q=#{keywords}\
      &center=#{longitude},#{latitude}\
      &distance=#{distance}".gsub(/\s+/, '')
    end

    def call_fb_url(url)
      headers = { 'Authorization' => "Bearer #{@fb_token}" }
      result = @cache.fetch(url) do
        HTTParty.get(url, :headers => headers)
      end

      successful?(result) ? result : raise_error(result)
    end

    def successful?(result)
      HTTP_ERROR.keys.include?(result.code) ? false : true
    end

    def raise_error(result)
      raise(HTTP_ERROR[result.code])
    end
  end
end
