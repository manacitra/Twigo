# frozen_string_literal: true

require 'roda'
require 'econfig'

module RefEm
  # Environment specific configuration
  class App < Roda
    plugin :environments

    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    use Rack::Session::Cookie, secret: config.SESSION_SECRET

    configure :development, :test do
      require 'pry'

      # Allows running <reload!> in pry to restart entire app
      def self.reload!
        exec 'pry -r ./init.rb'
      end
    end

    configure :development, :test, :app_test do
      ENV['DATABASE_URL'] = 'sqlite://' + config.DB_FILENAME
    end

    configure :app_test do
      require_relative '../spec/helpers/vcr_helper.rb'
      VcrHelper.setup_vcr
      VcrHelper.configure_vcr_for_ms(recording: :none)
    end

    configure :production do
      ENV['DATABASE_URL'] = 'postgres://mrwuznqrumkeci:c997196fc30f00178cf6480688fc90005c637d9bfc59955bed462722607c13aa@ec2-54-163-230-178.compute-1.amazonaws.com:5432/d9qssv086o5b19'
      # Use deployment platform's DATABASE_URL environment variable
    end

    configure do
      require 'sequel'
      DB = Sequel.connect(ENV['DATABASE_URL'])

      def self.DB # rubocop:disable Naming/MethodName
        DB
      end
    end
  end
end
