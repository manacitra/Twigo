# frozen_string_literal: true

require 'dry-struct'
require_relative '../mappers/reference_mapper.rb'

module RefEm
  module Entity
    # Domain entity for paper
    class Reference < Dry::Struct
      include Dry::Types.module

      attribute :id,           Strict::Integer
      attribute :title,        Strict::String
      attribute :author,       Strict::Array.of(String)
      attribute :year,         Strict::Integer
      attribute :date,         Strict::String
      attribute :references,   Strict::Array.of(String).optional
      attribute :field,        Strict::Array.of(String)
      attribute :doi,          Strict::String.optional
      attribute :venue_full,   Strict::String.optional
      attribute :venue_short,  Strict::String.optional
      attribute :volume,       Strict::Integer.optional
      attribute :journal_name, Strict::String.optional
      attribute :journal_abr,  Strict::String.optional
      attribute :issue,        Strict::Integer.optional
      attribute :first_page,   Strict::Integer.optional
      attribute :last_page,    Strict::Integer.optional
      # attribute :references,  Strict::Array.member(Paper).optional
    end
  end
end
