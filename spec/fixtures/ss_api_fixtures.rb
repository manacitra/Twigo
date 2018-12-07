# frozen_string_literal: true

require 'http'
require 'yaml'

def ss_api_search(doi)
  'http://api.semanticscholar.org/v1/paper/' + doi
end

def call_ss_api(url)
  HTTP.headers('Accept' => 'application/json').get(url)
end

ss_response = {}
ss_results = {}

## HAPPY project request
paper_doi_url = ss_api_search('10.1162/089120103321337421')
ss_response[paper_doi_url] = call_ss_api(paper_doi_url)
paper = ss_response[paper_doi_url].parse

ss_results['title'] = paper['title']

ss_results['authors'] = paper['authors'].map { |n| n['name'] }
# should be ["Franz Josef Och", "Hermann Ney"]

ss_results['citationVelocity'] = paper['citationVelocity']
# should be 232

ss_results['citation_titles'] = paper['citations'].map { |n| n['title'] }.compact
# should be "["ParaEval: Using Paraphrases to Evaluate Summaries Automatically",
# "An Annotation Scheme and Gold Standard for Dutch-English Word Alignment",...]

ss_results['citations'] = paper['citations']
# should list all citations detail

ss_results['citation_titles_valid?'] = (ss_results['citations'].count ==
                                        ss_results['citation_titles'].count)
# all citations should have title

ss_results['citation_dois'] = paper['citations'].map { |n| n['doi'] }.compact
# "should be ["10.1017/S1351324905003839", "10.3233/978-1-60750-641-6-133", ...]

ss_results['influential_citation_count'] = paper['influentialCitationCount']
# should be 541

ss_results['venue'] = paper['venue']
# should be "Computational Linguistics"

ss_results['focus_doi'] = paper['doi']

## BAD project request
bad_search_url = ss_api_search('foobar')
ss_response[bad_search_url] = call_ss_api(bad_search_url)
ss_response[bad_search_url].parse # makes sure any streaming finishes

File.write('spec/fixtures/ss_response.yml', ss_response.to_yaml)
File.write('spec/fixtures/ss_results.yml', ss_results.to_yaml)