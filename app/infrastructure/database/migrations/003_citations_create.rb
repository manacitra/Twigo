# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:citations) do
      primary_key :id
      # foreign_key :paper_doi, :papers

      String    :origin_id,       unique: true
      String    :title,           null: false
      String    :author
      Integer   :year
      String    :doi
      String    :venue
      Integer   :influential_citation_count

      DateTime :created_at
      DateTime :updated_at
      String   :link,            null: true
    end
  end
end
