# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module RefEm
  module Representer
    # Represents Citation information for API output
    class Citation < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :title
      property :link
    end
  end
end
