# frozen_string_literal: true

module Views
  # View for a single citation entity
  class Citation
    def initialize(citation, index = nil)
      @citation = citation
      @index = index
    end

    def detail_link
      "https://api.semanticscholar.org/#{@citation.origin_id}"
    end

    def index_str
      "#{@index+1}"
    end

    def index
      @index
    end

    def title
      @citation.title
    end
  end
end
