# frozen_string_literal: true

module RefEm
  module Repository
    # Repository for Paper Entities
    class Papers
      def self.all
        Database::PaperOrm.all.map { |db_paper| rebuild_entity(db_paper) }
      end

      def self.find_paper_content(id)
        db_paper = Database::PaperOrm.find(origin_id: id)
        rebuild_entity(db_paper)
      end

      def self.find_papers(id_list)
        id_list.map do |id|
          find_paper_content(id)
        end.compact
      end

      def self.find(entity)
        find_id(entity.origin_id)
      end

      def self.find_id(id)
        db_record = Database::PaperOrm.first(id: id)
        rebuild_entity(db_record)
      end

      # def self.find_from_doi(doi)
      #   db_record = Database::PaperOrm.first(doi: doi)
      #   rebuild_entity(db_record)
      # end

      def self.create(entity)
        raise 'Paper already exists' if find(entity)

        db_paper = PersistPaper.new(entity).call
        rebuild_entity(db_paper)
      end

      private

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Paper.new(
          # id:             db_record.id,
          # origin_id:      db_record.origin_id, 
          # title:          db_record.title,
          # author:         db_record.author,
          # year:           db_record.year,
          # date:           db_record.date,
          # field:          db_record.field,
          # references:     db_record.references,
          # doi:            db_record.doi

          db_record.to_hash.merge(
            references: References.rebuild_many(db_record.reference_papers),
            citations: Citations.rebuild_many(db_record.citation_papers)
          )
        )
      end

      def self.db_find_or_create(entity)
        Database::PaperOrm.find_or_create(entity)
      end

      # Helper class to persist paper and its authors to database
      class PersistPaper
        def initialize(entity)
          @entity = entity
        end

        def create_paper
          Database::PaperOrm.create(@entity.to_attr_hash) unless @entity.doi == nil
        end

        def call
          create_paper.tap do |db_paper|
            @entity.references.each do |reference|
              db_paper.add_reference_paper(References.db_find_or_create(reference))
              # puts '****************'
              # puts @entity.citations.class
              # puts @entity.references.class
            end
            @entity.citations.each do |citation|
              db_paper.add_citation_paper(Citations.db_find_or_create(citation))
            end
          end
        end
      end
    end
  end
end
