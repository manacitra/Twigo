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

        input[:response] = paper_from_microsoft(input)

        input[:response].success? ? Success(input) : Failure(response.message)
      rescue StandardError
        Failure('Could not access our API')
      end

      def reify_paper(input)
        puts "response: #{input[:response]}"
        unless input[:response].processing?
          
          redis = Redis.new(url: RefEm::Api.config.REDISCLOUD_URL)
          paper = redis.get(request_id)

          
          Representer::TopPaper.new(OpenStruct.new)
           .from_json(paper)
           .yield_self { |papers| input[:papers] = papers}
        end
          
        Success(input)
      rescue StandardError
        Failure('Error in the paper -- please try again later')
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
