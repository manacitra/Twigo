# frozen_string_literal: true

require 'json'
require_relative 'citation_mapper'

module RefEm
  # Provides access to microsoft data
  module MSPaper
    # Data Mapper: microsoft paper -> paper
    class PaperMapper
      #include RefEm::SSPaper
      def initialize(ms_token, gateway_class = MSPaper::Api)
        @token = ms_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(keywords, count)
        data = @gateway.paper_data(keywords, count).map { |data| 
          build_entity(data) 
        }
      end

      def build_entity(data)
        DataMapper.new(data).build_entity
      end
      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
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
            citation_velocity: citation_velocity,
            citation_dois: citation_dois,
            citation_titles: citation_titles,
            influential_citation_count: influential_citation_count,
            venue: venue
          )
        end

        def origin_id
          @data['Id']
        end

        def author
          author = ""
          @data['AA'].each { |auth|
            author += "#{auth['AuN']};"
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
          field = ""
          @data['F'].each { |f|
            field += "#{f};"
          }
          field
        end

        def doi
          @data['E']['DOI']
        end

        # get_from_ss = RefEm::SSPaper::SSMapper.new
        # .find_data_by(@data['E']['DOI'])

        def citation_velocity
          RefEm::SSPaper::SSMapper.new
                                  .find_data_by(doi)
                                  .citation_velocity
        end

        def citation_dois
          RefEm::SSPaper::SSMapper.new
                                  .find_data_by(doi)
                                  .citation_dois
        end

        def citation_titles
          RefEm::SSPaper::SSMapper.new
                                  .find_data_by(doi)
                                  .citation_dois
        end

        def influential_citation_count
          RefEm::SSPaper::SSMapper.new
                                  .find_data_by(doi)
                                  .influential_citation_count
        end

        def venue
          RefEm::SSPaper::SSMapper.new
                                  .find_data_by(doi)
                                  .venue
        end
      end
    end
  end
end
