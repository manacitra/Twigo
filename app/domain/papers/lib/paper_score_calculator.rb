# frozen_string_literal: true

module RefEm
  module Mixins
    # paper score calculation methods
    module PaperScoreCalculator
      def paper_score(paper, venue_weight)
        current_year = Time.new.year
        year_difference = current_year-paper.year
        venue_weight = 1 if venue_weight.nil?
        paper.citation_count/year_difference*venue_weight
      end
    end
  end
end
