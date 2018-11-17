# frozen_string_literal: true

require_relative 'references_list'
require_relative 'citations_list'

module Views
  # View for a single paper entity
  class Paper
    def initialize(paper, keyword, index = nil)
      @paper = paper
      @index = index
      @keyword = keyword
    end

    def graph_link
      "/paper_content/#{@keyword}/#{@paper.origin_id}"
    end

    def detail_link
      "https://academic.microsoft.com/#/detail/#{@paper.origin_id}"
    end

    def index_str
      "paper[#{@index}]"
    end

    def title
      @paper.title
    end
    
    def author
      @paper.author
    end

    def year
      @paper.year
    end

    def doi
      @paper.doi
    end

    def references
      ReferenceList.new(@paper.references)
    end

    def citations
      CitationList.new(@paper.citations)
    end

  end
end