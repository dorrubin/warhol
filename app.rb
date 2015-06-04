require_relative 'models/user'

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
			# @cards = Card.find_all_by_author_id(id)
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
			binding.pry
			@card.save
			redirect ("/browse")
			erb :browse, :layout => :app
		end
    

    # -- Collections --
		get ('/collections') do
			@all_cards = Card.all
			binding.pry
			if logged_in?
				erb :collections, :layout => :app
			else
				erb :collections
			end
		end

		get ('/collections/:username') do
			id = params[:id]
			erb :collection
		end



	end #class
end #module