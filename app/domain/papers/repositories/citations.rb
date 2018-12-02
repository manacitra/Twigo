# frozen_string_literal: true

module RefEm
  module Repository
    # Repository for Citation Entities
    class Citations
      def self.all
        Database::CitationOrm.all.map { |db_paper| rebuild_entity(db_paper) }
      end

      # find based on doi
      def self.find(entity)
        find_id(entity.doi)
      end

      def self.find_id(id)
        db_record = Database::CitationOrm.first(id: id)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Paper already exists' if find(entity)

        db_paper = PersistPaper.new(entity).call
        rebuild_entity(db_paper)
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_citation|
          Citations.rebuild_entity(db_citation)
        end
      end

      private

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Citation.new(
          id:                           db_record.id,
          origin_id:                    db_record.origin_id,
          title:                        db_record.title,
          author:                       db_record.author,
          year:                         db_record.year,
          doi:                          db_record.doi,
          venue:                        db_record.venue,
          influential_citation_count:   db_record.influential_citation_count
        )
      end

      def self.db_find_or_create(entity)
        Database::CitationOrm.find_or_create(entity.to_attr_hash)
      end

      # Helper class to persist paper and its authors to database
      class PersistPaper
        def initialize(entity)
          @entity = entity
        end

        def create_paper
          Database::CitationOrm.create(@entity.to_attr_hash)
        end

        def call
          create_paper
        end
      end
    end
  end
end
