class Service
  include MongoMapper::Document
  attr_accessor :search_relevance, :rank, :current_page, :total_pages
  USELESS_TERMS = ["a", "the", "of", "it", "for", "is", "i", "to", "in", "be", "and", "on"]
  PUNCTUATION = Regexp.new("[>@!*~`;:<?,./;'\"\\)(*&^{}#]")

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
  key :restrictions, String
  key :lat, Float
  key :lng, Float
  key :description, String
  key :search_terms, Array, :default => []
  key :status, String, :default => "active"
  key :services, Array, :default => []
  key :site_contact_name, String
  key :site_contact_email, String
  key :site_contact_phone, String
  key :parent_service
  key :internal_notes, String
  key :twitter, String
  key :facebook, String

  many :volunteer_opportunities
  many :research_opportunities

  timestamps!

  validates_presence_of :site_name, :address, :city, :state
  before_save :create_search_terms, :clean_services, :geocode

  def facebook
    if /http/ =~ attributes[:facebook]
      attributes[:facebook]
    else
      "http://#{attributes[:facebook]}"
    end
  end

  def clean_services
    # cleaning up some common mispellings
      # self.primary_service = primary_service.strip.downcase.gsub("/ ", "/").gsub('serivces', "services").gsub("transitioal", "transitional") rescue nil
      # self.secondary_service = secondary_service.strip.downcase.gsub("/ ", "/").gsub('serivces', "services").gsub("transitioal", "transitional")  rescue nil
      self.services = services.map(&:strip).map(&:downcase).uniq.delete_if(&:empty?)
  end

  def create_search_terms
    self.search_terms = [site_contact_email, site_contact_name, zip, state, quadrant, city].delete_if(&:nil?).map(&:downcase)
    [site_name, description, services].each do |term|
      next if term.nil?
      term = term.join(" ") if term.is_a? Array
      self.search_terms += term.gsub(/\//, " ").gsub(PUNCTUATION, "").downcase.split.uniq
    end
    self.search_terms.delete_if {|term| USELESS_TERMS.include? term}
    self.search_terms.delete_if(&:nil?)
    self.search_terms.delete_if(&:empty?)
    self.search_terms.uniq!
    self.name_parts = site_name.gsub(/\//, " ").gsub(PUNCTUATION, "").downcase.split.uniq
    self.name_parts.delete_if {|term| USELESS_TERMS.include? term}
  end

  scope :search,  lambda { |term| where(:status => "active", :search_terms => cleaned_search_terms(term)) }
  scope :active, lambda { where(:status => "active") }
  scope :pending, lambda { where(:status => "pending") }
  scope :updated, lambda { where(:status => "updated") }

  def cleaned_search_terms(search_term)
    unless search_term.nil?
      return search_term.gsub(/\//, " ").gsub(PUNCTUATION, " ").downcase.split.uniq
    end
  end

  def self.cleaned_search_terms(search_term)
    unless search_term.nil?
      return search_term.gsub(/\//, " ").gsub(PUNCTUATION, " ").downcase.split.uniq
    end
  end
  def rank_search(search_term)
    @rank = 0
    search_array = search_term.gsub(PUNCTUATION, "").downcase.split.uniq
    search_rank_array =  search_array & search_terms.uniq
    @rank = search_rank_array.length
    if site_name =~ %r[#{search_term.strip}]i
      @rank = @rank * 2
    end
    @rank
  end


  def self.service_types
    types = fields(:services).where(:status => "active").map(&:services).flatten
    types.compact.map(&:strip).map(&:downcase).uniq.delete_if(&:empty?).sort
  end

  def full_address
    "#{address} #{city}, #{state} #{zip}"
  end

  def google_maps_url
    # &f=d directs it straight to the directions function
    "http://maps.google.com/maps?q=#{URI.escape(full_address)}&f=d"
  end

  def any_address_parts_changed?
    return (address_changed? or zip_changed? or city_changed? or state_changed?)
  end
  def geocode
    return unless any_address_parts_changed?
    url = "http://maps.google.com/maps/api/geocode/json?"
    geocode_address = URI.escape(full_address)
    r = RestClient.get(url + "address="+geocode_address+"&sensor=false")
    results = Hashie::Mash.new(JSON.parse(r)).results[0]
    logger.debug "Geocoding Results: #{results.inspect}"
    return if results.nil?
    self.lat = results.geometry.location.lat
    self.lng = results.geometry.location.lng
  end
end
