# frozen_string_literal: true

require 'dry-validation'

module RefEm
  module Forms
    Keyword = Dry::Validation.Params do
      # only allows alphabet and space for title
      KEYWORD_REGEX = /^[a-zA-Z:"?][\sa-zA-Z:"?.(), | %20| \-]*$/
      # only allows search type to get 'keyword' or 'title' option
      SEARCH_TYPE_REGEX = /^keyword$|^title$/

      required(:keyword).filled(format?: KEYWORD_REGEX)
      required(:searchType).filled(format?: SEARCH_TYPE_REGEX)

      configure do
        config.messages_file = File.join(__dir__, 'errors/keyword_search.yml')
      end
    end
  end
end
