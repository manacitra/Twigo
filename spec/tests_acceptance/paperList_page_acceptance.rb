# frozen_string_literal: true

require_relative '../helpers/acceptance_helper.rb'
require_relative 'pages/home_page.rb'
require_relative 'pages/paperList_page.rb'
require_relative 'pages/paperContent_page.rb'

describe 'Paper list page Acceptance Tests' do
  include PageObject::PageFactory
  
  DatabaseHelper.setup_database_cleaner
  
  before do
    DatabaseHelper.wipe_database
    @headless = Headless.new
    @headless.start
    @browser = Watir::Browser.new :chrome
  end
  
  after do
    @browser.close
    @headless.destroy
  end
  
    
  it '(HAPPY) should see list of 10 papers related to keyword' do
    good_keyword = KEYWORDS
    searchType = 'keyword'
    
    # papers = RefEm::MSPaper::PaperMapper
    # .new(MS_TOKEN)
    # .find_papers_by_keywords(good_keyword)
    
    # GIVEN: user inputs a valid keyword
    visit HomePage do |page|
      page.add_new_keyword(good_keyword)
    end

    # WHEN: user submits the keyword
    visit(PaperListPage, using_params: { searchType: searchType, keyword: good_keyword
                                        }) do |page|
      # THEN: user should see the related paper list
      _(page.paper.count).must_equal 10

      paper_title = 'chord a scalable peer to peer lookup protocol for internet applications'
      _(page.first_paper.text).must_include paper_title
      _(page.first_paper_author_count).must_equal 7
      _(page.first_paper.text).must_include '2003'

    end
  end

  it '(HAPPY) should see list of 1 paper related to title' do
    good_title = 'chord a scalable peer to peer lookup protocol for internet applications'
    searchType = 'title'
    
    # papers = RefEm::MSPaper::PaperMapper
    # .new(MS_TOKEN)
    # .find_papers_by_keywords(good_keyword)
    
    # GIVEN: user inputs a valid keyword
    visit HomePage do |page|
      page.searchType_title
      page.add_new_keyword(good_title)
    end

    # WHEN: user submits the keyword
    visit(PaperListPage, using_params: { searchType: searchType, keyword: good_title
                                        }) do |page|
      # THEN: user should see the related paper list
      _(page.paper.count).must_equal 1

      paper_title = 'chord a scalable peer to peer lookup protocol for internet applications'
      _(page.first_paper.text).must_include paper_title
      _(page.first_paper_author_count).must_equal 7
      _(page.first_paper.text).must_include '2003'

    end
  end

  it '(HAPPY) can go to paper detail page' do
    good_keyword = KEYWORDS
    searchType = 'keyword'

    # GIVEN: user inputs a valid keyword
    visit HomePage do |page|
      page.add_new_keyword(good_keyword)
    end

    # WHEN: user goes to the paper page and click one of papers

    paper_title = 'chord a scalable peer to peer lookup protocol for internet applications'

    visit(PaperListPage, using_params: { searchType: searchType, keyword: good_keyword
                                        }) do |page|

      page.paper_called(paper_title).link.click
      
    end
    # THEN: user can see the paper detail
    paper_id = ID
    visit(PaperContentPage, using_params: { keyword: good_keyword, id: paper_id
                                        }) do |page|

      paper_year = '2003'
      paper_doi = '10.1109/TNET.2002.808407'
      _(page.main_paper).must_include paper_title
      _(page.main_paper).must_include paper_year
      _(page.main_paper).must_include paper_doi
    end
  end

  it '(BAD) user use invalid keyword to go to paper list page' do
    bad_keyword = 'disojcs'
    searchType = 'keyword'

    # GIVEN: user just inputs a invalid keyword
    # WHEN: user goes to the invalid url
    visit(PaperListPage, using_params: { keyword: bad_keyword, searchType: searchType}) do |page|
      # THEN: user will go to home page directly and show the error message
      _(page.warning_message.downcase).must_include "paper not found"
    end
  end
end
