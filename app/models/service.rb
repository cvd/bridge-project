class Service
  include MongoMapper::Document
  attr_accessor :search_relevance, :rank, :current_page, :total_pages
  USELESS_TERMS = ["a", "the", "of", "it", "for", "is", "i", "to", "in", "be"]
  PUNCTUATION = Regexp.new("[>@!*~`;:<?,./;'\"\\)(*&^{}#]")

  # SITE NAME,ADDRESS,QUADRANT,CITY,STATE,ZIP CODE,PHONE,HOURS,TRANSPORTATION,WEBSITE,PRIMARY SERVICE,SECONDARY SERVICE,Re2strictions
  key :site_name, String
  key :name_parts, Array
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
  key :status, String, :default => "active"
  key :services, Array, :default => []
  timestamps!

  validates_presence_of :site_name, :address, :city, :state
  before_save :create_search_terms
  before_save :clean_services
  before_save :geocode
  before_save :set_services
  
  def clean_services
    self.primary_service.strip!.gsub!("/ ", "/").gsub!('serivces', "services") rescue nil
    self.secondary_service.strip!.gsub!("/ ", "/").gsub!('serivces', "services") rescue nil
  end
  
  def set_services
    self.services = []
    
    self.services << self.primary_service.strip.downcase rescue nil
    self.services << self.secondary_service.strip.downcase rescue nil
  end  

  def create_search_terms
    [site_name, description, primary_service, secondary_service, quadrant].each do |term|
      next if term.nil?
      self.search_terms += term.gsub(/\//, " ").gsub(PUNCTUATION, "").downcase.split.uniq
      self.search_terms.delete_if {|term| USELESS_TERMS.include? term}
    end
    self.name_parts = site_name.gsub(/\//, " ").gsub(PUNCTUATION, "").downcase.split.uniq
    self.name_parts.delete_if {|term| USELESS_TERMS.include? term}
  end
  
  def calculate_search_relavance
    @search_relevance = 1
  end
  scope :search,  lambda { |search_term| where(:status => "active", :search_terms => search_term.gsub(/\//, " ").gsub(PUNCTUATION, " ").downcase.split.uniq) }
  
  def rank_search(search_term)
    @rank = 0    
    search_array = search_term.gsub(PUNCTUATION, "").downcase.split.uniq
    search_rank_array =  search_array & search_terms.uniq
    @rank = search_rank_array.length
  end

  def self.service_types_old
    all_services = all
    types = all_services.map(&:primary_service)
    types  += all_services.map(&:secondary_service)
    # puts types.uniq.inspect
    types.delete_if(&:nil?).map(&:capitalize).map(&:strip).uniq.delete_if(&:empty?).sort
  end

  def self.service_types
    types = fields(:services).map(&:services).flatten
    # puts types.uniq.inspect
    types.delete_if(&:nil?).map(&:capitalize).map(&:strip).uniq.delete_if(&:empty?).sort
  end
  
  def full_address
    "#{address} #{city}, #{state} #{zip}"
  end

  def google_maps_url
    # &f=d directs it straight to the directions function
    "http://maps.google.com/maps?q=#{URI.escape(full_address)}&f=d"
  end
  
  def geocode
    return if self.lat && self.lng
    url = "http://maps.google.com/maps/api/geocode/json?"
    geocode_address = URI.escape(full_address)
    r = RestClient.get(url + "address="+geocode_address+"&sensor=false")
    results = Hashie::Mash.new(JSON.parse(r)).results[0]
    logger.debug "Geocoding Results: #{results.inspect}"
    self.lat = results.geometry.location.lat
    self.lng = results.geometry.location.lng
  end
end