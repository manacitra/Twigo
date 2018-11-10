# frozen_string_literal: true

require 'sequel'

module RefEm
  module Database
    # Object Relational Mapper for Reference Entities
    class ReferenceOrm < Sequel::Model(:references)
      many_to_one :citing_doi,
                  class: :'RefEm::Database::PaperOrm',
                  key: :paper_id

      plugin :timestamps, update_on_create: true
    end
  end
end
