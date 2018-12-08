# frozen_string_literal: true

require 'dry/transaction'

module RefEm
  module Service
    # Retrieves array of all listed paper entities
    class ListPapers
      include Dry::Transaction

      step :get_api_list
      step :reify_list

      def get_api_list(id_list)
        Gateway::Api.new(RefEm::App.config)
          .paper_list(id_list)
          .yield_self do |result|
            result.success? ? Success(result.payload) : Failure(result.message)
          end
      rescue StandardError
        Failure('Could not access our API')
      end

      def reify_list(papers_json)
        Representer::PaperList.new(OpenStruct.new)
          .from_json(papers_json)
          .yield_self { |papers| Success(papers) }
      rescue StandardError
        Failure('Could not parse response from API')
      end
    end
  end
end