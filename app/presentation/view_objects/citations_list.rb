# frozen_string_literal: true

require_relative 'citation'

module Views
  # View for a list of citation entities
  class CitationList
    def initialize(citations)
      @citations = citations
      @citations = citations.map.with_index { |c, i| Citation.new(c, i)} unless citations.nil?
    end

    def each
      @citations.each do |c|
        yield c
      end
    end

    def five_citations
      citations = []
      unless @citations.nil?
        for num in 0..4
          citations.push(@citations[num])
        end
      end
      
      citations.each do |c|
        yield c unless c.nil?
      end
    end
  end
end
