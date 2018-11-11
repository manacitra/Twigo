# frozen_string_literal: true

require 'json'

module RefEm
  # Provides access to microsoft data
  module SSPaper
    # Data Mapper: microsoft paper -> paper
    class SSMapper
      def initialize(gateway_class = RefEm::SSPaper::Api)
        @gateway_class = gateway_class
        @gateway = @gateway_class.new
      end

      def find_data_by(doi)
        data = @gateway.paper_data(doi)
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data, @gateway_class).build_entity
      end
      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, gateway_class)
          @data = data
          @ssmapper = SSMapper.new(gateway_class)
        end

        def build_entity
          RefEm::Entity::Paper.new(
            id: nil,
            title: title,
            author: authors,
            year: nil,
            date: nil,
            field: nil,
            doi: focus_doi,
            citation_velocity: citation_velocity,
            citation_dois: citation_dois,
            citation_titles: citation_titles,
            influential_citation_count: influential_citation_count,
            venue: venue
          )
        end
        
        private

        def id; end
        def year; end
        def date; end
        def field; end

        def title
          @data['title']
        end

        def authors
          @data['authors'].map { |n| n['name'] }.compact
        end

        def citation_velocity
          @data['citationVelocity']
        end

        def citation_dois
          @data['citations'].map { |n| n['doi'] }.compact
        end

        def citation_titles
          @data['citations'].map { |n| n['title'] }.compact
        end

        def influential_citation_count
          @data['influentialCitationCount']
        end

        def venue
          @data['venue']
        end

        def focus_doi
          @data['doi']
        end
      end
    end
  end
end
