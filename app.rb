module App
	class Server < Sinatra::Base
		configure do 
			register Sinatra::Reloader
      set :sessions, true
		end

		get ('/') do
			erb :index
		end

	end #class
end #module