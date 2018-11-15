# frozen_string_literal: true

module RefEm
  module Entity
    # Domain entity for paper
    class Citation < Dry::Struct
      include Dry::Types.module

      attribute :id,                 Strict::Integer.optional
      attribute :origin_id,          Strict::String
      attribute :title,              Strict::String
      attribute :author,             Strict::Array.of(String)
      attribute :year,               Strict::Integer.optional
      attribute :doi,                Strict::String.optional
      attribute :venue,              Strict::String.optional

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key}
      end
    end
  end
end
