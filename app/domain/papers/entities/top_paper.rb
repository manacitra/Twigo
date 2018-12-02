# frozen_string_literal: true

module RefEm
  module Entity
    # Entity for top 5 references and citation about the main paper
    class TopPaper
      include Mixins::PaperRankCalculator
      include Mixins::PaperScoreCalculator

      def initialize(main_paper)
        @venue_score = Value::VenueScore.new
        @paper = main_paper
      end

      def references_rank
        reference_score_list = []
        @paper.references.each { |reference|
          venue_weight = @venue_score.get_venue_weight(reference.journal_name)
          reference_score = paper_score(reference, venue_weight)
          item = [reference, reference_score]
          reference_score_list.push(item)
        }
        paper_rank(reference_score_list)
      end

      def citations_rank
        citation_score_list = []
        @paper.citations.each { |citation|
          item = [citation, citation.influential_citation_count]
          citation_score_list.push(item)
        }
        paper_rank(citation_score_list)
      end
    end
  end
end