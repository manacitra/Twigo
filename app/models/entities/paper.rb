# frozen_string_literal: true

module RefEm
  module Entity
    # Domain entity for paper
    class Paper < Dry::Struct
      include Dry::Types.module

      attribute :id,          Strict::Integer
      attribute :title,       Strict::String
      attribute :author,      Strict::Array.of(String)
      attribute :year,        Strict::Integer
      attribute :date,        Strict::String
      attribute :field,       Strict::Array.of(String)
      attribute :doi,         Strict::String.optional

#      attribute :references,  Strict::Array.member(Paper).optional
    end
  end
end
