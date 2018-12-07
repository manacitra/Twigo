# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
class VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'
  MS_CASSETTE = 'ms_api'
  SS_CASSETTE = 'ss_api'

  def self.setup_vcr
    VCR.configure do |c|
      c.cassette_library_dir = CASSETTES_FOLDER
      c.hook_into :webmock
      c.ignore_localhost = true
    end
  end

  def self.configure_vcr_for_ms(recording: :new_episodes)
    VCR.configure do |c|
      c.filter_sensitive_data('<MS_TOKEN>') { MS_TOKEN }
      c.filter_sensitive_data('<MS_TOKEN_ESC>') { CGI.escape(MS_TOKEN) }
    end

    VCR.insert_cassette(
      MS_CASSETTE,
      record: recording,
      match_requests_on: %i[method uri headers],
      allow_playback_repeats: true
    )
  end

  def self.configure_vcr_for_ss(recording: :new_episodes)
    VCR.configure do
    end

    VCR.insert_cassette(
      SS_CASSETTE,
      record: recording,
      match_requests_on: %i[method uri headers],
      allow_playback_repeats: true
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
