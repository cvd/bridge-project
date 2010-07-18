require 'rubygems'
require 'json'
require 'hashie'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bridge-project'


services = Service.all()

a = []

services.each do |s|
  a << s.primary_service if s.primary_service
  a << s.secondary_service  if s.secondary_service
end

puts a.inspect