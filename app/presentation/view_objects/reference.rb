# frozen_string_literal: true

module Views
    # View for a single reference entity
    class Reference
      def initialize(reference, index = nil)
        @reference = reference
        @index = index
      end
  
      def detail_link
        "https://academic.microsoft.com/#/detail/#{@reference.origin_id}"
      end
  
      def index_str
        "#{@index+1}"
      end

      def index
        @index
      end
  
      def title
        @reference.title
      end
  
    end
  end