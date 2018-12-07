# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module RefEm
  module Representer
    # Represents venue score
    class VenueScore < Roar::Decorator
      include Roar::JSON

      property :get_venue_weight
    end
  end
end
