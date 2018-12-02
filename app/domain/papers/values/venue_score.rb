# frozen_string_literal: true
require 'yaml'

module RefEm
  module Value
    # Value of venue score (delegates to hash)
    class VenueScore < SimpleDelegator
      # rubocop:disable Style/RedundantSelf
      
      def initialize
        @venue_weight = venue_weight
      end

      def get_venue_weight(venue)
        @venue_weight[venue] 
      end

      def venue_weight
        v_weight = YAML.load_file('config/journal_of_computer_science_3.yaml')[0]
      end
    end
  end
end