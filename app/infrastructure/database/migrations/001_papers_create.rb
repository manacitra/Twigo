# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:papers) do
      primary_key :id
       
      Integer   :origin_id, unique: true
      String    :title, unique: true, null: false
      String    :author
      Integer   :year
      String    :date
      String    :field
      String    :doi, null: true
      String    :link, null: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
