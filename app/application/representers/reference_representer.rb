# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'citation_representer.rb'

module RefEm
  module Representer
    # Represents Reference information for API output
    class Reference < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :title
      property :reference_content
      property :link
    end
  end
end
