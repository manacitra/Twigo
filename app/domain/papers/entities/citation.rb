# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module RefEm
  module Entity
    # Domain entity for paper
    class Citation < Dry::Struct
      include Dry::Types.module

      attribute :id,                                      Strict::Integer.optional
      attribute :origin_id,                               Strict::String
      attribute :title,                                   Strict::String
      attribute :author,                                  Strict::String.optional
      attribute :year,                                    Strict::Integer.optional
      attribute :doi,                                     Strict::String.optional
      attribute :venue,                                   Strict::String.optional
      attribute :influential_citation_count,              Strict::Integer.optional

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key}
      end
    end
  end
end
