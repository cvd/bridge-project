require 'rubygems'
require 'fasterCSV'
require 'json'
# require 'mongomapper'
# require 'hashie'
# 
# $LOAD_PATH.unshift(File.dirname(__FILE__))
# $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'app'))
# require 'models/service'
PADRINO_ENV = 'development' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

# class Bacon::Context
#   include Rack::Test::Methods
# end
# 
# def app
#   ##
#   # You can handle all padrino applications using instead:
#   #   Padrino.application
#   Bridge.tap { |app|  }
# end


filename = 'outfile.csv'
rows = []
i=0
csv = FasterCSV.foreach(filename, {:headers=> true})  do |row|
  h = {}
  row.each do |key,value|
    h[key.to_sym] = value
  end
  h[:primary_service].downcase! unless h[:primary_service].nil?
  h[:secondary_service].downcase!  unless h[:secondary_service].nil?
  s = Service.create(h)
  puts s.inspect
  s.save
end