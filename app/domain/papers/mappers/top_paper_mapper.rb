# frozen_string_literal: true

module RefEm
  module MSPaper
    # Get Top five references or citations about main paper
    class TopPaperMapper
      def initialize(paper)
        @paper = paper
      end

      def build_entity
        RefEm::Entity::TopPaper.new(@paper)
      end

      def top_papers
        references_list = top_references
        # citation_list = top_citations
        puts "reference list: #{references_list}"
        @paper.ref_to_top_ref(references_list)
        @paper
      end

      def top_references
        references_list = build_entity.references_rank
      end

      def top_citations
        citations_list = build_entity.citations_rank
      end
    
    end
  end
end