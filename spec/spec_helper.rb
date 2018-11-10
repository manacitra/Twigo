# frozen_string_literal: false

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'

require 'pry' # for debugging

require_relative '../init.rb'

KEYWORDS = 'internet'.freeze
COUNT = '10'.freeze
MS_TOKEN = RefEm::App.config.MS_TOKEN
CORRECT = YAML.safe_load(File.read('spec/fixtures/ms_results.yml'))
ERROR = {}
