require 'rubygems'
require 'fasterCSV'
require 'restclient'
require 'json'
require 'hashie'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bridge-project'


filename = 'outfile.csv'
rows = []
i=0
csv = FasterCSV.foreach(filename, {:headers=> true})  do |row|
  h = {}
  row.each do |key,value|
    h[key.to_sym] = value
  end
  s = Service.create(h)
  puts s.inspect
  s.save
end