# frozen_string_literal: true

require 'json'
require_relative 'citation_mapper'

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

      def find_papers_by_keywords(keywords, searchType)
        show_detail = false
        search_results = []
        paper_count = 0
        @gateway.full_paper_data(keywords, searchType).map { |data|
          unless paper_count >= 10 || data['E']['DOI'].nil? || data['RId'] == []
            search_results.push(build_entity(data, show_detail))
            paper_count += 1
          end
        }
        search_results
      end

      def find_paper(id)
        show_detail = true
        @gateway.paper_data(id).map { |data|
          build_entity(data, show_detail)
        }
      end

      def find_main_paper(id)
        show_detail = true
        build_entity(data, show_detail)
      end

      def build_entity(data, show_detail)
        DataMapper.new(data, @token, @gateway_class, show_detail).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, token, gateway_class, show_detail)
          @data = data
          @show_detail = show_detail
          # puts "==============="
          # puts data["Ti"]
          # puts data["RId"]
          @reference_mapper = ReferenceMapper.new(
            token, gateway_class
          )
          @citation_mapper = CitationMapper.new
        end

        def build_entity
          RefEm::Entity::Paper.new(
            id: nil,
            origin_id: origin_id,
            title: title,
            author: author,
            year: year,
            date: date,
            field: field,
            doi: doi,
            references: references,
            citations: citations
          )
        end

        def origin_id
          @data['Id']
        end

        def author
          author = ''
          @data['AA'].each { |auth|
            author += "#{auth};"
          }
          author
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

        def field
          field = ''
          @data['F'].each { |f|
            field += "#{f};"
          }
          field
        end

        # connect with reference mapper
        def references
          @reference_mapper.load_several(@data['RId']) if @show_detail == true
        end

        def citations
          @citation_mapper.find_data_by(@data['E']['DOI']) if @show_detail == true
        end

        def doi
          @data['E']['DOI']
        end

 
      end
    end
  end
end
