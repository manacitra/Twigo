# frozen_string_literal: true
require_relative 'paper_score_calculator.rb'

module RefEm
  module Mixins
    # paper rank calculation methods
    module PaperRankCalculator
      # rank paper list by score
      # paper list: [paper, score]
      def paper_rank(paper_list)
        # descend paper score
        paper_list.sort { |x, y| y[1] <=> x[1] }
        top_five_papers = []
        for num in 0..4
          top_five_papers.push(paper_list[num])
        end

        top_five_papers
      end
    end
  end
end