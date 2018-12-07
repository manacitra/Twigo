# frozen_string_literal: true

require_relative '../helpers/acceptance_helper.rb'
require_relative 'pages/home_page.rb'
require_relative 'pages/paperList_page.rb'

describe 'Homepage Acceptance Tests' do
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

  describe 'Visit Home page' do
    it '(HAPPY) should not see anything other than defaut homepage' do
      # GIVEN: user is on the home page
      # WHEN: user visits the home page
      visit HomePage do |page|
        # THEN: user should see basic headers, no projects and a welcome message
        (page.title_heading).must_equal 'RefEm'
        (page.text_field.present?).must_equal true
        (page.button.present?).must_equal true
      end
    end
  end
  describe 'Search papers based on keyword' do
    it '(HAPPY) should be able to search papers by keywords' do
      # GIVEN: user is on the home page
      visit HomePage do |page|
        # WHEN: user adds a keyword and submit
        good_keyword = KEYWORDS
        searchType = 'keyword'
        page.add_new_keyword(good_keyword)

        # THEN: user should go to paper list page
        @browser.url.include? 'internet'
        visit(PaperListPage, using_params: { keyword: good_keyword, searchType: searchType}) 
      end
    end
    it '(HAPPY) should be able to search papers by title' do
    # GIVEN: user is on the home page
      visit HomePage do |page|
        # WHEN: user adds a keyword and submit
        good_title = 'chord a scalable peer to peer lookup protocol for internet applications'
        searchType = 'title'
        page.searchType_title
        page.add_new_keyword(good_title)
        
        # THEN: user should go to paper list page
        visit(PaperListPage, using_params: { keyword: good_title, searchType: searchType}) 
      end
    end
    it '(BAD) should not be input invalid keywords' do
      # GIVEN: user is on the home page
      visit HomePage do |page|
        # WHEN: user inputs a bad/invalid keyword
        bad_keyword = 'disojcs'
        page.add_new_keyword(bad_keyword)
        # THEN: user should see a warning message
        _(page.warning_message.downcase).must_include 'not found'
      end
    end
    it '(BAD) should not receive nil keywords' do
      # GIVEN: user is on the home page
      visit HomePage do |page|
        # WHEN: user inputs a bad/invalid keyword
        nil_keyword = ''
        page.add_new_keyword(nil_keyword)
        # THEN: user should see a warning message
        _(page.warning_message.downcase).must_include 'please enter'
      end
    end
    it "(SAD) should be able to search, but API can't serve it" do
      # GIVEN: user is on the home page
      visit HomePage do |page|
        # WHEN: user try to search the sad keyword
        sad_keyword = 'social'
        page.add_new_keyword(sad_keyword)
        # THEN: user should see a warning message
        _(page.warning_message.downcase).must_include 'trouble'
      end
    end
  end
end