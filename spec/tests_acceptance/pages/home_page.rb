# frozen_string_literal: true

# Page object for home page
class HomePage
  include PageObject

  page_url RefEm::App.config.APP_HOST

  div(:warning_message, id: 'flash_bar_danger')

  h1(:title_heading, id: 'main_header')
  text_field(:paper_query_input, id: 'paper_query_input')
  button(:add_button, id: 'paper_search-submit')
  radio_button(:search_keyword, id: 'search_keyword')
  radio_button(:search_title, id: 'search_title')

  def add_new_keyword(keyword)
    self.paper_query_input = keyword
    self.add_button
  end

  def searchType_title
    self.select_search_title
  end
end