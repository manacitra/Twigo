# frozen_string_literal: true

require 'dry/monads'

module RefEm
  module Service
    # Retrieves array of all listed paper entities
    class ListPapers
      include Dry::Monads::Result::Mixin

      def call(id_list)
        papers = Repository::For.klass(Entity::Paper)
          .find_papers(id_list)

        Success(papers)
      rescue StandardError
        Failure('Could not access database')
      end
    end
  end
end