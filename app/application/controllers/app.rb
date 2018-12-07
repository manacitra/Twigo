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
            # need refactor
            # for now we only accept 1 parameter in the query
            # query format: keyword
            # Redirect viewer to project page
            keyword = routing.params['paper_query'].downcase
            #decide which type user want to search (keyword or title)
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
          find_paper = Service::ShowPaperList.new.call(keywords)
          
          if find_paper.failure?
            flash[:error] = find_paper.failure
            routing.redirect '/'
          end

          paper = find_paper.value!
          
          viewable_papers = Views::PaperList.new(paper[:papers], paper[:keyword])

          view "find_paper", locals: { papers: viewable_papers}
        end
      end
      routing.on 'paper_content' do
        
        
        routing.on String do |id|
          # DELETE /paper_content/paper_id
          routing.delete do
            session[:watching].delete(id.to_i)

            routing.redirect '/'
          end

          routing.get do
            # GET /paper_content/paper_id
            result = Service::ShowPaperContent.new.call(id: id)

            if result.failure?
              flash[:error] = result.failure
              paper = []
            else
              paper = result.value!.paper
            end

    
            # get main paper object value
            session[:watching].insert(0, paper.origin_id).uniq!

            viewable_paper = Views::Paper.new(paper)

            view 'paper_content', locals: { paper: viewable_paper }
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