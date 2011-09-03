require 'rubygems'
require 'fastercsv'
require 'json'
PADRINO_ENV = 'production'
PADRINO_ENV = 'development' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

reject = [
  'parent_service',
  'secondary_service',
  'name_parts',
  'search_terms',
  'primary_service',
  '_id'
]

FasterCSV.open("output.csv", 'w') do |csv|
  attributes = Service.first.attributes.map {|k,v| k}
  attributes = attributes.reject {|c| reject.include?(c) }
  csv << attributes

  Service.active.each do |service|
    attrs = service.attributes.map {|k,v| v}
    csv << attributes.map do |attr|
      value = service.attributes[attr]
      if attr == 'services'
        value.join(", ")
      elsif
        value.is_a?(Time)
        value.strftime('%m/%d/%Y %I:%M %p')
      else
        value
      end
    end
  end
end
