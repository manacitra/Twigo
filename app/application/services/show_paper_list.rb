# frozen_string_literal: true

require 'dry/transaction'

module RefEm
  module Service
    # Transaction to store project from MS API to database
    class ShowPaperList
      include Dry::Transaction

      step :validate_input
      step :find_paper
      step :reify_papers

      private

      def validate_input(input)
        if input.success?
          keyword = input[:keyword].downcase
          searchType = input[:searchType].downcase
          
          Success(keyword: keyword, searchType: searchType)
        else
          Failure(input.errors.values.join('; '))
        end
      end

      def find_paper(input)
        begin
          result = paper_from_microsoft(input)
          result.success? ? Success(result.payload) : Failure(result.message)
        rescue StandardError => e
          puts e.inspect + '\n' + e.backtrace
          Failure('Could not find papers by the keyword')
        end
      end

      def reify_papers(paper_json)
        begin
          Representer::PaperList.new(OpenStruct.new)
           .from_json(paper_json)
           .yield_self { |papers| Success(papers)}
          
        rescue StandardError
          Failure('Error in the papers -- please try again later')
        end
      end

      # following are support methods that other services could use

      def paper_from_microsoft(input)
        Gateway::Api.new(RefEm::App.config)
          .papers_list(input[:searchType], input[:keyword])
      end
    end
  end
end
