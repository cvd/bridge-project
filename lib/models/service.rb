class Service
  include MongoMapper::Document
  attr_accessor :search_relevance
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
  key :search_terms, Array, :default => []
  
  before_save :create_search_terms
  before_save :geocode
  
  def create_search_terms
    [site_name, description, primary_service, secondary_service, website, quadrant].each do |term|
      next if term.nil?
      self.search_terms += term.split
    end
  end
  
  def calculate_search_relavance
    @search_relevance = 1
  end
  scope :search,  lambda { |search_term| where(:search_terms => search_term.split) }
  
  
  def geocode
    self.lat = 1
    self.lng = 2
    return

    url = "http://maps.google.com/maps/api/geocode/json?"
    address = "#{address} #{city}, #{state}, #{zip}"
    puts "Geocoding: #{address}"
    address = URI.escape(address)
    r = RestClient.get(url + "address="+address+"&sensor=false")
    results = Hashie::Mash.new(JSON.parse(r)).results[0]
    # puts results.inspect
    self.lat = results.geometry.location.lat 
    self.lng = results.geometry.location.lng
  end
end