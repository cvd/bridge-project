require 'restclient'
require 'hashie'
class Service
  include MongoMapper::Document
  # SITE NAME,ADDRESS,QUADRANT,CITY,STATE,ZIP CODE,PHONE,HOURS,TRANSPORTATION,WEBSITE,PRIMARY SERVICE,SECONDARY SERVICE,Re2strictions
  key :site_name, String
  key :address, String
  key :quadrant, String
  key :city, String
  key :state, String
  key :zip, String
  key :phone, String
  key :hours, String
  key :transportation, String
  key :website, String
  key :primary_service, String
  key :secondary_service, String
  key :restrictions, String
  key :lat, Float
  key :lng, Float
  key :description, String

  before_save :create_search_terms
  before_save :geocode
  
  def create_search_terms
    # puts keys.inspect
  end
  
  def geocode
    # return if address.nil?
    # return if city.nil?
    # return if state.nil?
    # return if zip.nil?
    url = "http://maps.google.com/maps/api/geocode/json?"
    address = "#{address} #{city}, #{state}, #{zip}"
    puts "Geocoding: #{address}"
    address = URI.escape(address)
    r = RestClient.get(url + "address="+address+"&sensor=false")
    results = Hashie::Mash.new(JSON.parse(r)).results[0]
    puts results.inspect
    self.lat = results.geometry.location.lat 
    self.lng = results.geometry.location.lng
  end
end