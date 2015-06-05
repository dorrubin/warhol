require_relative 'models/user'
require_relative 'models/card'

module Warhol
	class Server < Sinatra::Base
		configure do 
			register Sinatra::Reloader
      set :sessions, true
		end
    
    def current_user_id
      session[:user_id]
    end

    def current_username
      session[:username]
    end

    def logged_in?
      !current_user_id.nil?
    end

   	#Default Values
  	DEFAULT_URL = "http://www.anothermag.com/art-photography/3995/20-brilliant-andy-warhol-quotes"

    # -- HOMEPAGE --
		get ('/') do
			erb :index
		end

		post '/signin' do
			query = "SELECT * FROM users WHERE username = $1 AND password = $2"
     	@user = $db.exec_params(query, [params[:username], params[:password]])
	    if @user.first.nil?
	    	@message = "Invalid Login"
	      erb :index
	     else
	       user_id = @user.first["id"]
	       username = @user.first["username"]
	       session[:user_id] = user_id
	       session[:username] = username
	       redirect "/browse"
	    end
    end
    
    # -- REGISTER --
		get ('/register') do
			erb :register
		end

		post ('/register') do
      @user =  User.new(params)
      @user.save
      redirect ("/")
		end


    # -- APP --
		get ('/browse') do
			@url = @url || DEFAULT_URL
			erb :browse, :layout => :app
		end

		post ('/browse') do
			@url = params[:url]
			erb :browse, :layout => :app
		end

		post ('/browse/create') do
			params["author_id"] = current_user_id
			params["author"] = current_username
			@card = Card.new(params)
			@card.save
			redirect ("/browse")
			erb :browse, :layout => :app
		end
    

    # -- Collections --
		get ('/collections') do
			@all_cards = Card.all
			if params[:tag]
				tag = params[:tag]
				redirect ("/collections/topic/#{tag}")
			elsif logged_in?
				@current_user = current_username
				erb :collections, :layout => :app
			else
				erb :collections
			end
		end


			

		get ('/collections/topic/:tag') do
			@tag = params[:tag]
			tag = params[:tag]
			@topic_cards = Card.find_by_tag(tag)
			if logged_in?
				@current_user = current_username
				erb :topic, :layout => :app
			else
				erb :topic
			end
		end

		get ('/collections/:username') do
			username = params[:username]
			@user_cards = Card.find_all_by_author(username)
			if logged_in?
				@current_user = current_username
				erb :collection, :layout => :app
			else
				erb :collection
			end
		end

		get ('/collections/:username/:id') do
			username = params[:id]
			id = params[:id]
			@card = Card.find_by_id(id)
			almost_value = @card.first.tags.delete!"}"
			@format_value = @card.first.tags.delete"{"
			binding.pry
			if logged_in? and username = current_username
				erb :card, :layout => :app
			else
				status 403
				redirect ('/')
			end
		end

		delete ('/collections/:id') do
			params["author"] = current_username
			id = params[:id]
			@card = Card.find_by_id(id).first
			@card.remove_db
			redirect ("/collections/#{current_username}")
		end
		
		patch ('/collections/:id') do
			id = params[:id]
			@card = Card.find_by_id(id).first
			@card.tags = "{#{params[:tags]}}"
			@card.value = params[:value]
			@card.edit(params)
			redirect ("/collections/#{current_username}")
    end

	end #class
end #module