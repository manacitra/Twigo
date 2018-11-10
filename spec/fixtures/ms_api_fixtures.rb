# frozen_string_literal: true

require 'net/http'
require 'yaml'
require 'json'

config = YAML.safe_load(File.read('config/secrets.yml'))
token = config['MS_TOKEN']
puts "the token is" . token
# token = "d74bd5a4fdb74fc59d46175f39b220a3"

def microsoft_api_url(keywords, count)  
  uri = URI('https://api.labs.cognitive.microsoft.com/academic/v1.0/evaluate')
  query = URI.encode_www_form({
    # Request parameters
    'expr' => "W == '#{keywords}'",
    'model' => 'latest',
    'count' => "#{count}",
    'offset' => '0',
    'attributes' => 'Ti,AA.AuN,Y,D,F.FN,E'
  })

  if uri.query && uri.query.length > 0
    uri.query += '&' + query
  else
    uri.query = query
  end

  uri
end

def call_microsoft_url(uri, token)
  request = Net::HTTP::Get.new(uri.request_uri)
  # Request headers
  request['Ocp-Apim-Subscription-Key'] = token
  # Request body
  response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    http.request(request)
  end

  response
end

microsoft_response = {}
microsoft_results = {}

## happy requests
data_url = microsoft_api_url('internet', 10)
microsoft_response['data_url'] = call_microsoft_url(data_url, token)
data = JSON.parse(microsoft_response['data_url'].body)
entity_data = data['entities']

microsoft_results['Id'] = entity_data[0]['Id']
# should be 2118428193

microsoft_results['Title'] = entity_data[0]['Ti']
# should be 'chord a scalable peer to peer lookup protocol for internet applications'

author_array = []
entity_data[0]['AA'].map { |author|
  author_array.push(author['AuN'])
}
microsoft_results['Author'] = author_array
# array size should be 6

microsoft_results['Year'] = entity_data[0]['Y']
# should be 2003

microsoft_results['Date'] = entity_data[0]['D']
# should be 2003-02-01

field_array = []
entity_data[0]['F'].map { |field|
  field_array.push(field['FN'])
}
microsoft_results['Field'] = field_array
# array size should be 11

extend_data = JSON.parse(entity_data[0]['E'])
microsoft_results['DOI'] = extend_data['DOI']

## bad request
bad_data_url = microsoft_api_url('internet', -5)
microsoft_response['bad_data_url'] = call_microsoft_url(bad_data_url, token)
microsoft_response['bad_data_url'] = JSON.parse(microsoft_response['bad_data_url'].body)

File.write('spec/fixtures/ms_response.yml', microsoft_response.to_yaml)
File.write('spec/fixtures/ms_results.yml', microsoft_results.to_yaml)