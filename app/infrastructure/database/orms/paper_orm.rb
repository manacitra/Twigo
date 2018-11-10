# frozen_string_literal: true

require 'sequel'

module RefEm
  module Database
    # Object Relational Mapper for Paper Entities
    class PaperOrm < Sequel::Model(:papers)
      one_to_many :reference_doi,
                  class: :'RefEm::Database::ReferenceOrm'

      one_to_many :citation_doi,
                  class: :'RefEm::Database::CitationOrm'
      
      
      plugin :timestamps, update_on_create: true
    end
  end
end
