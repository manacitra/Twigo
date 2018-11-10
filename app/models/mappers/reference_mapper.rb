# frozen_string_literal: true
require 'json'

# This module only connected to SS API
module RefEm
  # Provides access to microsoft data
  module SSPaper
    # Data Mapper: microsoft paper -> paper
    class RefMapper
      def initialize(gateway_class = SSPaper::Api)
        @gateway_class = gateway_class
        @gateway = @gateway_class.new
      end

      def find(keywords, count)
        data = @gateway.paper_data(keywords, count)
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data['entities'][0]
        end

        def build_entity
          RefEm::Entity::Paper.new(
            id: id,
            year: year,
            date: date,
            doi: doi
          )
        end

        def id
          @data['Id']
        end

        def year
          @data['Y']
        end

        def date
          @data['D']
        end

        def doi
          @data['E']['DOI']
        end
      end
    end
  end
end
