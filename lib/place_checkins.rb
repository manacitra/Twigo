# frozen_string_literal: true

module FacebookPlaces
  # Model to get place and checkin number
  class PlaceCheckin
    def initialize(place_data, data_source)
      @place = JSON.parse(place_data)['data'][0]
    end

    def place_checkins
      {@place['name'] => @place['checkins']}
    end
  end
end
