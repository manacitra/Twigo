# frozen_string_literal: true

require 'httparty'
require 'yaml'

config = YAML.safe_load(File.read('config/secrets.yml'))
headers = { 'Authorization' => "Bearer #{config['FB_TOKEN']}" }

def fb_api_url(keywords,longitude, latitude, distance)
  "https://graph.facebook.com/v3.1/search
  ?type=place
  &fields=name,checkins,picture
  &q=#{keywords}
  &center=#{longitude},#{latitude}
  &distance=#{distance}"
end

def call_fb_url(headers, url)
  HTTParty.get(url, :headers => headers)
end

fb_response = {}
fb_results = {}



## happy requests
project_url = fb_api_url('sea', '24.7943758', '120.9715205', '10000')
fb_response[project_url] = call_fb_url(headers, project_url)
project = JSON.parse(fb_response[project_url])

fb_results['data'] = project['data']
#should not be nil

## bad request
bad_project_url = fb_api_url('error', '24.7943758','120.9715205', '10000')
fb_response[bad_project_url] = call_fb_url(headers, bad_project_url)
fb_response[bad_project_url] = JSON.parse(fb_response[bad_project_url])

File.write('spec/fixtures/fb_response.yml', fb_response.to_yaml)
File.write('spec/fixtures/fb_results.yml', fb_results.to_yaml)