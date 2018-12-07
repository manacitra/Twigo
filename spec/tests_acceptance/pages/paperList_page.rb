# frozen_string_literal: true

# Page object for Paper List page
class PaperListPage
  include PageObject

  page_url RefEm::App.config.APP_HOST + '/find_paper/<%=params[:searchType]%>/<%=params[:keyword]%>'

  div(:warning_message, id: 'flash_bar_danger')
  table(:paper_table, id: 'papers_table')
  a(:f_paper_link, id: 'paper[0].link')

  indexed_property(
    :papers,
    [
      [:span, :title,        { id: 'paper[%s].title' }],
      [:a,    :http_url,     { id: 'paper[%s].link' }],
      [:span, :author,       { id: 'paper[%s].author' }],
      [:span, :year,         { id: 'paper[%s].year' }],
      [:span, :doi,          { id: 'paper[%s].doi' }]
    ]
  )

  def first_paper
    papers[0]
  end

  def first_paper_author_count
    papers[0].author.split(';').count
  end

  def paper
    paper_table_element.trs(id: 'paper_row')
  end

  def paper_called(title)
    paper.find { |p| p.a(class: 'paper_detail').text.eql? title}
  end
end