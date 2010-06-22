require 'rubygems'
require 'fasterCSV'
require 'restclient'
require 'json'
require 'hashie'

filename = 'bridge_data.csv'
rows = []
i=0
url, rows, i = "http://maps.google.com/maps/api/geocode/json?", [], 0
csv = FasterCSV.foreach(filename, {:headers=> true})  do |row|
  i+=1
  m = Hashie::Mash.new(row.to_hash)
  address = "#{row['ADDRESS']} #{row['CITY']}, #{row['STATE']}, #{row['ZIP CODE']}"
  puts "#{i}. Geocoding: #{address}"
  address = URI.escape(address)
  r = RestClient.get(url + "address="+address+"&sensor=false")
  results = Hashie::Mash.new(JSON.parse(r)).results[0]

  m.lat, m.lgn = results.geometry.location.lat, results.geometry.location.lng
  puts "#{m.lat}, #{m.lgn}"
  rows << m
  sleep 1
end


r=rows[0]
# puts r.inspect
# puts r.hashie_inspect
# puts r.hash_inspect
# p r.methods.sort
headers = r.keys

FasterCSV.open("outfile.csv", "w") do |csv|
  csv << headers
  rows.each do |row|
    csv << headers.collect {|h| row[h] }
  end
end





# url = "http://maps.google.com/maps/api/geocode/json?address=1000%20R%20St.%20washington%20dc&sensor=false"
# r = RestClient.get(url)
# p r


__END__

from: http://snippets.dzone.com/posts/show/1260
require 'uri'
foo = "http://google.com?query=hello"

bad = URI.escape(foo)
good = URI.escape(foo, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))

bad_uri = "http://mysite.com?service=#{bad}&bar=blah"
good_uri = "http://mysite.com?service=#{good}&bar=blah"

puts bad_uri
# outputs "http://mysite.com?service=http://google.com?query=hello&bar=blah"

puts good_uri
# outputs "http://mysite.com?service=http%3A%2F%2Fgoogle.com%3Fquery%3Dhello&bar=blah"