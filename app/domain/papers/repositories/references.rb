# frozen_string_literal: true

module RefEm
    module Repository
      # Repository for Paper Entities
      class References
        def self.all
          Database::ReferenceOrm.all.map { |db_paper| rebuild_entity(db_paper) }
        end
  
        def self.find(entity)
          find_id(entity.origin_id)
        end
  
        def self.find_id(id)
          db_record = Database::ReferenceOrm.first(id: id)
          rebuild_entity(db_record)
        end
  
        def self.create(entity)
          raise 'Paper already exists' if find(entity)
          db_paper = PersistPaper.new(entity).call
          rebuild_entity(db_paper)
        end

        def self.rebuild_many(db_records)
            db_records.map do |db_reference|
              References.rebuild_entity(db_reference)
            end
          end
  
        private
  
        def self.rebuild_entity(db_record)
          return nil unless db_record
  
          Entity::Reference.new(
            id:             db_record.id,
            origin_id:      db_record.origin_id, 
            title:          db_record.title,
            author:         db_record.author,
            year:           db_record.year,
            date:           db_record.date,
            field:          db_record.field,
            doi:            db_record.doi,
            references:     db_record.references,
            venue_full:     db_record.venue_full,
            venue_short:    db_record.venue_short,
            volume:         db_record.volume,
            journal_name:   db_record.journal_name,
            journal_abr:    db_record.journal_abr,
            issue:          db_record.issue,
            first_page:     db_record.first_page,
            last_page:      db_record.last_page,
            citation_count: db_record.citation_count,
            link:           db_record.link
          )
        end
  
        def self.db_find_or_create(entity)
          Database::ReferenceOrm.find_or_create(entity.to_attr_hash)
        end
  
        # Helper class to persist paper and its authors to database
        class PersistPaper
          def initialize(entity)
            @entity = entity
          end
  
          def create_paper
            Database::ReferenceOrm.create(@entity.to_attr_hash)
          end
  
          def call
            create_paper
          end
        end
      end
    end
  end
  