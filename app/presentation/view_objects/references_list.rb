# frozen_string_literal: true

require_relative 'reference'

module Views
  # View for a list of reference entities
  class ReferenceList
    def initialize(references)
      @references = references.map.with_index { |r, i| Reference.new(r, i)}
    end

    def each
      @references.each do |r|
        yield r
      end
    end

    def five_references

      references = []
      for num in 0..4
        references.push(@references[num])
      end
      references.each do |r|
        yield r
      end
    end
  end
end
