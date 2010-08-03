PADRINO_ENV = 'development' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")


s = Service.where(:quadrant => "NW").only(:primary_service).limit(100).group
put s.inspect