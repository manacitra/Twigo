# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
class VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze
  MS_CASSETTE = 'ms_api'.freeze

  def self.setup_vcr
    VCR.configure do |c|
      c.cassette_library_dir = CASSETTES_FOLDER
      c.hook_into :webmock
    end
  end

  def self.configure_vcr_for_ms
    VCR.configure do |c|
      c.filter_sensitive_data('<MS_TOKEN>') { MS_TOKEN }
      c.filter_sensitive_data('<MS_TOKEN_ESC>') { CGI.escape(MS_TOKEN) }
    end

    VCR.insert_cassette(
      MS_CASSETTE,
      record: :new_episodes,
      match_requests_on: %i[method uri headers]
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
