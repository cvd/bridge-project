require 'rubygems'
require 'sinatra'
require 'mongo_mapper'

['models','controllers','helpers'].each do |folder|
  basedir =  File.join(File.dirname(File.expand_path(__FILE__)), folder)
  Dir.glob(basedir+"/*.rb").each {|file| require file}
end

set :haml, {:format => :html5 }
set :root, File.dirname(__FILE__)
set :views, Proc.new { File.join(root, "views") }
set :environment, :development
enable :sessions, :clean_trace, :logging

MongoMapper.database = 'bridge_project_dev'

include Sinatra::Partials

before do
  
end

get "/" do
  erb :index
end

get "/services" do
  
end

get "/search" do
  result = Service.find_by_site_name(params[:site_name])
  erb :search, :locals => {:result => result}
end

post "/search" do
  params[:site_name] = params[:q] if params[:site_name].nil?
  result = Service.find_by_site_name(params[:site_name])
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