# frozen_string_literal: true

require_relative '../../helpers/spec_helper.rb'
require_relative '../../helpers/vcr_helper.rb'
require_relative '../../helpers/database_helper.rb'

describe 'ShowPaperContent Service Integration Test' do
  VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    VcrHelper.configure_vcr_for_ms(recording: :none)
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Retrieve and store project' do
    before do
      DatabaseHelper.wipe_database
    end

    it 'HAPPY: should be able to find and save paper of interest to database' do
      # GIVEN: a user request paper content
      picked_paper = RefEm::MSPaper::PaperMapper
        .new(MS_TOKEN).find_paper(ID)
      paper = picked_paper[0]
      object_rebuilt = RefEm::Repository::For.entity(paper).create(paper)

      # WHEN: a paper is picked from the list and service is called with the request object
      paper_made = RefEm::Service::ShowPaperContent.new.call(id:ID)

      # THEN: the result should report success
      _(paper_made.success?).must_equal true

      # ..and provide a paper entity with the right details
      rebuilt = paper_made.value!

      _(rebuilt.origin_id).must_equal(object_rebuilt.origin_id)
      _(rebuilt.title).must_equal(object_rebuilt.title)
      _(rebuilt.year).must_equal(object_rebuilt.year)
      _(rebuilt.doi).must_equal(object_rebuilt.doi)
    end

    it 'HAPPY: should find and return existing project in database' do
      # GIVEN: a search request for paper already in the database:
      db_paper = RefEm::Service::ShowPaperContent.new.call(id:ID).value!

      # WHEN: a paper is picked from the list and service is called
      paper_made = RefEm::Service::ShowPaperContent.new.call(id:ID)

      # THEN: the result should report success..
      (paper_made.success?).must_equal true

      # .. and find the same paper that was already in the db
      rebuilt = paper_made.value!
      _(rebuilt.origin_id).must_equal(db_paper.origin_id)

      # ..and provide a project entity with the right details
      _(rebuilt.title).must_equal(db_paper.title)
      _(rebuilt.year).must_equal(db_paper.year)
      _(rebuilt.doi).must_equal(db_paper.doi)
    end

    it 'BAD: should gracefully fail for invalid paper id' do
      # GIVEN: an invalid MS paper ID is requested
      BAD_ID = '2118428193a'

      # WHEN: the service is called with invalid ID
      paper_made = RefEm::Service::ShowPaperContent.new.call(id:BAD_ID)

      # THEN: the service should report failure with an error message
      (paper_made.success?).must_equal false
      (paper_made.failure.downcase).must_include 'could not find'
    end
  end
end
