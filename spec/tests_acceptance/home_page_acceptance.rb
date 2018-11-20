# frozen_string_literal: true

require_relative '../helpers/acceptance_helper.rb'
require_relative 'pages/home_page.rb'

describe 'Acceptance Tests' do
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

  describe 'Homepage' do
    describe 'Visit Home page' do
      it '(HAPPY) should not see anything other than defaut homepage' do
        # GIVEN: users are on the home page
        # WHEN: they visit the home page
        visit HomePage do |page|
          # THEN: user should see basic headers, no projects and a welcome message
          (page.title_heading).must_equal 'RefEm'
          (page.text_field.present?).must_equal true
          (page.button.present?).must_equal true
        end
      end
    end
    describe 'Search papers based on keyword' do
      it '(HAPPY) should be able to search papers' do
        # GIVEN: users are on the home page
        visit HomePage do |page|
          # WHEN: they add enter a keyword and submit
          good_keyword = KEYWORDS
          page.add_new_keyword(good_keyword)

          # THEN: they should find themselves a list of papers
          @browser.url.include? 'internet'
        end
      end
      it '(BAD) should not be input invalid keywords' do
        # GIVEN: users are on the home page
        visit HomePage do |page|
          # WHEN: they input a bad/invalid keyword
          bad_keyword = 'crazy input'
          page.add_new_keyword(bad_keyword)
          # THEN: they should see a warning message
          _(page.warning_message.downcase).must_include 'not found'
        end
      end
      it '(BAD) should not receive nil keywords' do
        # GIVEN: users are on the home page
        visit HomePage do |page|
          # WHEN: they input a bad/invalid keyword
          nil_keyword = ''
          page.add_new_keyword(nil_keyword)
          # THEN: they should see a warning message
          _(page.warning_message.downcase).must_include 'please enter'
        end
      end
      it "(SAD) should be able to search, but API can't serve it" do
        # GIVEN: users are on the home page
        visit HomePage do |page|
          # WHEN: they try
          sad_keyword = 'social'
          page.add_new_keyword(sad_keyword)
          # THEN: they should see a warning message
          _(page.warning_message.downcase).must_include 'trouble'
        end
      end
    end
  end
end