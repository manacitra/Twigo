# frozen_string_literal: true
require 'json'

require_relative 'reference_mapper.rb'

module RefEm
  # Provides access to microsoft data
  module MSPaper
    # Data Mapper: microsoft paper -> paper
    class PaperMapper
      def initialize(ms_token, gateway_class = MSPaper::Api)
        @token = ms_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(keywords, count)
        @gateway.paper_data(keywords, count).map { |data|
          # puts "#kelas dari data ini adalah:"
          # puts data.class
          build_entity(data)
        }
      end

      def build_entity(data)
        DataMapper.new(data, @token, @gateway_class).build_entity
      end
      
      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, token, gateway_class)
          @data = data
          # puts "------- this is data--------"
          # puts @data["RId"]
          # puts "----------------------------"
          @reference_mapper = ReferenceMapper.new(
            token, gateway_class
          )          
        end

        def build_entity
          RefEm::Entity::Paper.new(
            id: id,
            title: title,
            author: author,
            year: year,
            date: date,
            references: references,
            field: field,
            doi: doi,
            venue_full: venue_full,
            venue_short: venue_short,
            volume: volume,
            journal_name: journal_name,
            journal_abr: journal_abr,
            issue: issue,
            first_page: first_page,
            last_page: last_page
          )
        end

        private

        def id
          @data['Id']
        end

        def author
          @data['AA']
        end

        def title
          @data['Ti']
        end

        def year
          @data['Y']
        end

        def date
          @data['D']
        end

        def references
          @reference_mapper.find_several(@data['RId'])
        end
        
        def field
          @data['F']
        end

        def doi
          @data['E']['DOI']
        end

        def venue_full
          @data['E']['VFN']
        end

        def venue_short
          @data['E']['VSN']
        end

        def volume
          @data['E']['V']
        end

        def journal_name
          @data['E']['BV']
        end

        def journal_abr
          @data['E']['PB']
        end

        def issue
          @data['E']['I']
        end

        def first_page
          @data['E']['FP']
        end

        def last_page
          @data['E']['LP']
        end
      end
    end
  end
end
