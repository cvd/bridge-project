require 'rubygems'
require 'sinatra'
require 'restclient'
require 'hashie'
require 'mongo_mapper'
require 'rack-flash'

# require "digest/sha1"


['helpers','models','controllers'].each do |folder|
  basedir =  File.join(File.dirname(File.expand_path(__FILE__)), folder)
  Dir.glob(basedir+"/*.rb").each {|file| require file}
end

use Rack::Session::Cookie, :secret => 'A1 sauce 1s so good you should use 1t on a11 yr st34ksssss'
#if you want flash messages
use Rack::Flash



# set :public, 'public'

set :haml, {:format => :html5 }
set :root, File.dirname(__FILE__)
set :views, Proc.new { File.join(root, "views") }
set :environment, :development
enable :sessions, :clean_trace, :logging

database_definitions = {
  :production => "bridge_project",
  :development => "bridge_project_dev",
  :test => "bridge_project_test"
}

MongoMapper.database = database_definitions[:development]

include Sinatra::Partials

before do
  
end

get "/" do
  erb :index
end

get "/search" do
  result = Service.find_by_site_name(params[:site_name])
  erb :search, :locals => {:result => result}
end

post "/search" do
  result = Service.search(params[:q])
  puts result.inspect
  if request.xhr?
    return result.to_json
  end
  erb :search, :locals => {:result => result}
end


get "/add" do 
  erb :add
end

post "/add" do 
  s = Service.new(params)
  s.save
  s.to_json
end

