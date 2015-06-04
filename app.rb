module App
	class Server < Sinatra::Base
		configure do 
			register Sinatra::Reloader
      set :sessions, true
		end
    
    def current_user
      session[:user_id]
    end

    def logged_in?
      !current_user.nil?
    end

    # -- HOMEPAGE --
		get ('/') do
			erb :index
		end

		post '/signin' do
			query = "SELECT * FROM users WHERE username = $1 AND password = $2"
     	@user = $db.exec_params(query, [params[:username], params[:password]])
	    if @user.first.nil?
	    	#if password is wrong, redirect to homepage
	    	@message = "Invalid Login"
	      erb :index
	     else
	       user_id = @user.first["id"]
	       #save user_id into the session
	       session[:user_id] = user_id
	       #redirect somewhere
	       redirect "/"
	    end
    end
    
    # -- Collections --
		get ('/collections') do
			erb :collections
		end

    # -- REGISTER --
		get ('/register') do
			erb :register
		end

		post ('/register') do
      name = params[:name]
      email = params[:email]
      username = params[:username]
      phone = params[:phone]
      password = params[:password]
      query = "INSERT INTO users (name, email, username, phone, password) VALUES ($1, $2, $3, $4, $5) RETURNING id"
      $db.exec_params(query, [name, email, username, phone, password])
      redirect ("/browse")
		end

    # -- APP --
		get ('/browse') do
			 erb :browse, :layout => :app
		end


	end #class
end #module