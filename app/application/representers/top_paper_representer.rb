# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'venue_score_representer.rb'
require_relative 'paper_representer.rb'

module RefEm
  module Representer
    # Represents venue score
    class TopPaper < Roar::Decorator
      include Roar::JSON

      property :paper, extend: Representer::Paper,
                       class: Value::OpenStructWithLinks
    end
  end
end
