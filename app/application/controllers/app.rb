# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'
require_relative 'helpers.rb'

module RefEm
  # Web App
  class App < Roda
    include RouteHelpers
    plugin :render, engine: 'slim', views: 'app/presentation/views'
    plugin :assets, path: 'app/presentation/assets',
                    css: 'style.css',
                    js: 'customize.js'
    plugin :halt
    plugin :flash
    plugin :all_verbs
    plugin :caching

    use Rack::MethodOverride

    route do |routing|
      routing.assets # load CSS

      # GET /
      routing.root do
        session[:watching] ||= []

        result = Service::ListPapers.new.call(session[:watching])

        if result.failure?
          flash[:error] = result.failure
          papers = []
        else
          papers = result.value!.papers
        end

        session[:watching] = papers.map(&:origin_id)

        viewable_papers = Views::PaperList.new(papers)
        view 'home', locals: { papers: viewable_papers }
      end

      routing.on 'find_paper' do
        routing.is do
          # POST /find_paper/
          routing.post do
            # Redirect viewer to project page
            keyword = routing.params['paper_query'].downcase
            # decide which type user want to search (keyword or title)
            searchType = routing.params['searchType'].downcase

            if keyword == '' || keyword == nil
              flash[:error] = 'Please enter the keyword!'
              routing.redirect '/'
            end

            routing.redirect "find_paper/#{searchType}/#{keyword}"
          end

          # GET /find_paper/
          routing.get do
            flash[:error] = 'Please enter the keyword!'
            routing.redirect '/'
          end
        end

        routing.on String, String do |searchType, keyword|
          # POST /find_paper/searchtype/keyword
          keywords = Forms::Keyword.call(
            keyword: keyword,
            searchType: searchType
          )
          result = Service::ShowPaperList.new.call(keywords)

          if result.failure?
            flash[:error] = result.failure
            paper = []
          else
            papers = result.value!.papers
          end

          viewable_papers = Views::PaperList.new(papers)

          view 'find_paper', locals: { papers: viewable_papers}
        end
      end
      routing.on 'paper' do
        routing.on String do |id|
          # DELETE /paper/paper_id
          routing.delete do
            session[:watching].delete(id)

            routing.redirect '/'
          end

          routing.get do
            # GET /paper/paper_id
            result = Service::ShowPaperContent.new.call(id: id)

            if result.failure?
              flash[:error] = 'Too Many Citations: Thread Limit'
              routing.redirect '/'
            end

            ranked_paper = OpenStruct.new(result.value!)

            if ranked_paper.response.processing?
              flash.now[:notice] = 'Paper is being gotten and analyzed'
            else
              paper = ranked_paper.papers
              # add the paper into cache
              session[:watching].insert(0, paper.paper.origin_id).uniq!
              viewable_paper = Views::Paper.new(paper[:paper])
            end

            # add processing bar view object
            processing = Views::PaperProcessing.new(
              App.config, ranked_paper.response
            )

            view 'paper_content', locals: { paper: viewable_paper,
                                            processing: processing }
          end
        end
        # GET /paper_content/
        routing.get do
          flash[:error] = 'Please enter the correct url'
          routing.redirect '/'
        end
      end
    end
  end
end
