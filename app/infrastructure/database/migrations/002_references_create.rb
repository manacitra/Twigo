# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:references) do
      primary_key :id

      Integer   :origin_id,       unique: true
      String    :title,           null: false
      String    :author
      Integer   :year
      String    :date
      String    :field
      String    :references,      null: true
      String    :doi,             null: true
      String    :venue_full,      null: true
      String    :venue_short,     null: true
      Integer   :volume,          null: true
      String    :journal_name,    null: true
      String    :journal_abr,     null: true
      Integer   :issue,           null: true
      Integer   :first_page,      null: true
      Integer   :last_page,       null: true
      Integer   :citation_count,  null: true
      String   :link,            null: true

      # attribute :references,  Strict::Array.member(Paper).optional
    end
  end
end
