# frozen_string_literal: true
# frozen_string_literal: true

require_relative 'paper_representer'

module RefEm
  module Representer
    # Represents PaperList information for API output
    class PaperList < Roar::Decorator
      include Roar::JSON

      collection :papers, extend: Representer::Paper,
                          class: Value::OpenStructWithLinks
    end
  end
end
