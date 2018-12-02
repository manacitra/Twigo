# frozen_string_literal: true

require 'json'

module RefEm
  # Provides access to microsoft data
  module MSPaper
    # Data Mapper: microsoft paper -> paper
    class CitationMapper
      def initialize(gateway_class = RefEm::MSPaper::SSApi)
        @gateway_class = gateway_class
        @gateway = @gateway_class.new
      end

      # build all citations from a paper
      def find_data_by(doi)
        data = @gateway.paper_data(doi)
        unless data['error']
          data['citations'].map { |citation|
            build_entity(citation)
          }
        end
      end

      def build_entity(data)
        DataMapper.new(data, @gateway_class).build_entity
      end
      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data, gateway_class)
          @data = data
          @ssmapper = CitationMapper.new(gateway_class)
        end

        def build_entity
          RefEm::Entity::Citation.new(
            id: nil,
            origin_id: origin_id,
            title: title,
            author: author,
            year: year,
            doi: doi,
            venue: venue,
            influential_citation_count: influential_citation_count
            # citation_velocity: citation_velocity,
            # citation_dois: citation_dois,
            # citation_titles: citation_titles,
            
          )

          #paper id from paper table as foreign key
        end

        private

        def origin_id
          @data['paperId']
        end

        def title
          @data['title']
        end

        def author
          author = ''
          @data['authors'].each { |auth|
            author += "#{auth['name']};"
          }
          author

          # @data['authors'].map { |n| n['name'] }
        end

        def year
          @data['year']
        end

        def doi
          @data['doi']
        end

        def venue
          @data['venue']
        end

        def influential_citation_count
          @data['influentialCitationCount']
        end

        # def citation_velocity
        #   @data['citationVelocity']
        # end

        # def citation_dois
        #   @data['citations'].map { |n| n['doi'] }.compact
        # end

        # def citation_titles
        #   @data['citations'].map { |n| n['title'] }.compact
        # end

        # def influential_citation_count
        #   @data['influentialCitationCount']
        # end
      end
    end
  end
end
