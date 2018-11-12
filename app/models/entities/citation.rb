# frozen_string_literal: true

module RefEm
  module Entity
    # Domain entity for paper
    class FromSS < Dry::Struct
      include Dry::Types.module

      attribute :origin_id,                    Strict::String.optional
      attribute :citation_velocity,            Strict::Integer
      attribute :citation_dois,                Strict::Array.of(String) # sometimes doi is null
      attribute :citation_titles,              Strict::Array.of(String)
      attribute :influential_citation_count,   Strict::Integer
      attribute :venue,                        Strict::String
      attribute :focus_doi,                    Strict::String # Paper that we interested in
    end
  end
end
