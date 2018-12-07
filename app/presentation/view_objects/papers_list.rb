# frozen_string_literal: true

require_relative 'paper'

module Views
  # View for a list of paper entities
  class PaperList
    def initialize(papers, keyword = nil)
      @papers = papers.map.with_index { |p, i| Paper.new(p, i)}
      @keyword = keyword
    end

    def each
      @papers.each do |p|
        yield p
      end
    end
    
    def keyword
      @keyword
    end

    def any?
      @papers.any?
    end
  end
end
