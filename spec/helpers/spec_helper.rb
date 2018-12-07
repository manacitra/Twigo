# frozen_string_literal: true

ENV['RACK_ENV'] ||= 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'

require 'pry' # for debugging

require_relative '../../init.rb'

KEYWORDS = 'internet'
SEARCH_TYPE = 'keyword'
ID = '2118428193'
PAPER_TITLE = 'chord a scalable peer to peer lookup protocol for internet applications'
PAPER_DOI = '10.1109/TNET.2002.808407'
PAPER_YEAR = '2003'
SS_CORRECT = YAML.safe_load(File.read('spec/fixtures/ss_results.yml'))
ERROR = {}
DOI = '10.1162/089120103321337421'


# Helper methods
def homepage
  RefEm::App.config.APP_HOST
end
