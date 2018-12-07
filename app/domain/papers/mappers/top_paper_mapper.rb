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
        citations_list = top_citations
        paper_contain_top_ref_cit_hash = @paper.to_attr_hash
        paper_contain_top_ref_cit_hash[:id] = nil

        # create main paper contain top five references and citations
        paper_contain_top_ref_cit = RefEm::Entity::Paper.new(
            paper_contain_top_ref_cit_hash.merge(
            references: references_list,
            citations: citations_list
          )
        )

        paper_contain_top_ref_cit
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