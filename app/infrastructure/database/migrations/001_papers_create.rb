# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:papers) do
      primary_key :id

      String    :title, unique: true, null: false
      String    :author
      Integer   :year
      DateTime  :date
      String    :field
      String    :doi, unique: true, null: true

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
