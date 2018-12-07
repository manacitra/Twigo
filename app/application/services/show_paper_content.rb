# frozen_string_literal: true

require 'dry/transaction'

module RefEm
  module Service
    # Transaction to store paper from MS API to database
    class ShowPaperContent
      include Dry::Transaction

      step :find_main_paper
      step :reify_paper

      private

      def find_main_paper(input)

        result = paper_from_microsoft(input)

        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError
        Failure('Could not access our API')
      end

      def reify_paper(paper_json)
        begin
          Representer::TopPaper.new(OpenStruct.new)
           .from_json(paper_json)
           .yield_self { |papers| Success(papers)}
          
        rescue StandardError
          Failure('Error in the paper -- please try again later')
        end
      end
      

      # following are support methods that other services could use

      def paper_from_microsoft(input)
        Gateway::Api.new(RefEm::App.config)
          .paper_content(input[:id])
      rescue StandardError
        raise 'Could not find papers by the ID'
      end
    end
  end
end
