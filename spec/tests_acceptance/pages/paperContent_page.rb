# frozen_string_literal: true

# Page object for Paper Content page
class PaperContentPage
  include PageObject

  page_url RefEm::App.config.APP_HOST + '/paper/<%=params[:keyword]%>/<%=params[:id]%>'

  div(:warning_message, id: 'flash_bar_danger')
  table(:papers_table, id: 'papers_table')
  table(:main_paper_table, id: 'main_paper_table')

  indexed_property(
    :reference_papers,
    [
      [:span, :title,      { id: 'reference[%s].title' }],
      [:a,    :http_url,   { id: 'reference[%s].link' }]
    ]
  )

  indexed_property(
    :citation_papers,
    [
      [:span, :title,      { id: 'reference[%s].title' }],
      [:a,    :http_url,   { id: 'reference[%s].link' }]
    ]
  )

  def main_paper
    main_paper_table
  end

  # get first reference paper
  def first_reference_paper
    reference_papers[0]
  end

  # get first citation paper
  def first_citation_paper
    citation_papers[0]
  end
end
