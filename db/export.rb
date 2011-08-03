require 'rubygems'
require 'fastercsv'
require 'json'

PADRINO_ENV = 'development' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")


FasterCSV.open("output.csv", 'w') do |csv|
  csv << Service.first.attributes.map {|k,v| k}

  Service.active.each do |service|
    csv << service.attributes.map {|k,v| v}
  end
end
