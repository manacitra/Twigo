# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'citation_representer'
require_relative 'reference_representer'

module RefEm
  module Representer
    # Represents Paper information for API output
    class Paper < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :origin_id
      property :title
      property :author
      property :year
      property :doi
      property :link
      collection :citations, extend: Representer::Citation, class: OpenStruct
      collection :refs, extend: Representer::Reference, class: OpenStruct

      link :self do
        "#{Api.config.API_HOST}/api/v1/paper/#{origin_id}/"
      end

      private

      def origin_id
        represented.origin_id
      end
    end
  end
end
