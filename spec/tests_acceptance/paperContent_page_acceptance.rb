# frozen_string_literal: true

require_relative '../helpers/acceptance_helper.rb'
require_relative 'pages/paperContent_page.rb'

describe 'Paper content page Acceptance Tests' do
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
  
    
  it '(HAPPY) should see the main paper detail, references and citations' do

    # GIVEN: user use valid keyword, paper ID to type on the url
    paper_id = ID

    # WHEN: user go to paper detail page directly
    visit(PaperContentPage, using_params: { id: paper_id
                                        }) do |page|
      # THEN: user should main paper(paper detail, references and citations)             
      # main paper detail test  
      _(page.main_paper).must_include PAPER_TITLE
      _(page.main_paper).must_include PAPER_YEAR
      _(page.main_paper).must_include PAPER_DOI
      
      # reference papers
      reference_title = 'chord a scalable peer to peer lookup service for internet applications'
      _(page.first_reference_paper.text).must_include reference_title

      # citation papers
      citation_title = 'Bypass: Providing secure DHT routing through bypassing malicious peers'
      _(page.first_citation_paper.text).must_include reference_title
    end
  end

  it '(BAD) user use invalid paper ID to go to paper detail page' do
    bad_paper_id = '98237492343242'

    # GIVEN: user inputs a invalid keyword and paper id
    # WHEN: user goes to the invalid url
    visit(PaperContentPage, using_params: { id: bad_paper_id
                                        }) do |page|
      # THEN: user will go to home page directly and show the error message
      _(page.warning_message.downcase).must_include "could not find papers"
    end
  end
end
