require "sinatra/base"
require "sinatra/reloader"
require "pry"
require "pg"
require "redcarpet"

require_relative 'db/connection'
require_relative 'app'


use Rack::MethodOverride

run Warhol::Server
