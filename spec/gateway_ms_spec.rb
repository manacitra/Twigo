# frozen_string_literal: false

require_relative 'spec_helper.rb'
require_relative 'helpers/vcr_helper.rb'

describe 'Test microsoft academic search library' do
  before do
    VcrHelper.configure_vcr_for_ms
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Paper information' do
    it "HAPPY: should provide correct paper attributes" do
      paper = RefEm::MSPaper::PaperMapper
              .new(MS_TOKEN)
              .find(KEYWORDS, 1)
      paper.size.must_equal 1
      first_paper = paper[0]
      puts "the paper details are:"
      puts paper[0].id
      puts paper[0].title
      puts paper[0].author
      puts paper[0].year
      puts paper[0].date
      puts paper[0].doi
      puts "references:"
      x = 1
      paper[0].references.map { |ref| 
        puts "#{x}. ======================"
        puts "id: #{ref.id}"
        puts "title: #{ref.title}"
        x += 1
      }
      puts paper[0].venue_full
      puts paper[0].venue_short
      puts paper[0].volume
      puts paper[0].journal_name
      puts paper[0].journal_abr
      puts paper[0].issue
      puts paper[0].first_page
      puts paper[0].last_page
      _(first_paper.id).must_equal CORRECT['Id']
      _(first_paper.year).must_equal CORRECT['Year']
      _(first_paper.date).must_equal CORRECT['Date']
      _(first_paper.doi).must_equal CORRECT['DOI']
    end

    it 'SAD: should have error on incorrect counts' do
      proc do
        RefEm::MSPaper::PaperMapper
          .new(MS_TOKEN)
          .find(KEYWORDS, '-5')
      end.must_raise RefEm::MSPaper::Api::Response::BadRequest
    end

    it 'SAD: should raise exception when unautorized' do
      proc do
        RefEm::MSPaper::PaperMapper
          .new('NO_TOKEN')
          .find(KEYWORDS, COUNT)
      end.must_raise RefEm::MSPaper::Api::Response::Unauthorized
    end
  end
end
