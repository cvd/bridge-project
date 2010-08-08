class Service
  include MongoMapper::Document
  attr_accessor :search_relevance, :rank, :current_page, :total_pages
  USELESS_TERMS = ["a", "the", "of", "it", "for", "is", "i", "to", "in", "be"]
  PUNCTUATION = Regexp.new("[>@!*~`;:<?,./;'\"\\)(*&^{}#]")

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

  timestamps!
  
  before_save :create_search_terms
  validates_presence_of :site_name, :address
  # before_save :geocode
  
  def create_search_terms
    [site_name, description, primary_service, secondary_service, quadrant].each do |term|
      next if term.nil?
      self.search_terms += term.gsub(PUNCTUATION, "").downcase.split.uniq
      self.search_terms.delete_if {|term| USELESS_TERMS.include? term}
    end
  end
  
  
  
  def calculate_search_relavance
    @search_relevance = 1
  end
  scope :search,  lambda { |search_term| where(:search_terms => search_term.gsub(PUNCTUATION, "").downcase.split.uniq) }
  
  def rank_search(search_term)
    @rank = 0    
    search_array = search_term.gsub(PUNCTUATION, "").downcase.split.uniq
    search_rank_array =  search_array & search_terms.uniq
    @rank = search_rank_array.length
  end

  def self.service_types
    all.map(&:primary_service).uniq.sort
  end
  
  def geocode
    url = "http://maps.google.com/maps/api/geocode/json?"
    address = "#{address} #{city}, #{state}, #{zip}"
    logger.debug "Geocoding: #{address}"
    address = URI.escape(address)
    r = RestClient.get(url + "address="+address+"&sensor=false")
    results = Hashie::Mash.new(JSON.parse(r)).results[0]
    
    logger.debug results.inspect
    self.lat = results.geometry.location.lat 
    self.lng = results.geometry.location.lng
  end
end