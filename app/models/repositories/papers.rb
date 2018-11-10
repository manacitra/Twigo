# frozen_string_literal: true

module RefEm
  module Repository
    # Repository for Paper Entities
    class Papers
      def self.all
        Database::PaperOrm.all.map { |db_paper| rebuild_entity(db_paper) }
      end

      def self.find_id(id)
        db_record = Database::PaperOrm.first(id: id)
        rebuild_entity(db_record)
      end

      def self.find_from_doi(doi)
        db_record = Database::PaperOrm.first(doi: doi)
        rebuild_entity(db_record)
      end

      def self.create(entity)
        raise 'Paper already exists' if find(entity)

        db_paper = PersistPaper.new(entity).call
        rebuild_entity(db_paper)
      end

      private

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Paper.new(
          title:   db_record.title,
          year:    db_record.year,
          doi:     db_record.doi,
          field:   db_record.field
        )
      end

      # Helper class to persist paper and its authors to database
      class PersistPaper
        def initialize(entity)
          @entity = entity
        end

        def self.db_find_or_create(entity)
          Database::PaperOrm.find_or_create(entity.to_attr_hash)
        end

        def create_paper
          Database::PaperOrm.create(@entity.to_attr_hash)
        end

        def call
          author = Papers.db_find_or_create(@entity.author)

          create_paper.tap do |db_paper|
            db_paper.update(author: author)
          end
        end
      end
    end
  end
end
