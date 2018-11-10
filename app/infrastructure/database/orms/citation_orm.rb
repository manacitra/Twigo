# frozen_string_literal: true

require 'sequel'

module RefEm
  module Database
    # Object Relational Mapper for Reference Entities
    class CitationOrm < Sequel::Model(:citations)
      many_to_one :referencing_doi,
                  class: :'RefEm::Database::PaperOrm',
                  key: :paper_id

      plugin :timestamps, update_on_create: true
    end
  end
end
