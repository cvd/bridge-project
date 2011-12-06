class VolunteerOpportunity
  include MongoMapper::Document
  attr_accessor :search_relevance, :rank, :current_page, :total_pages
  USELESS_TERMS = ["a", "the", "of", "it", "for", "is", "i", "to", "in", "be", "and", "on"]
  PUNCTUATION = Regexp.new("[>@!*~`;:<?,./;'\"\\)(*&^{}#]")

  key :title, String
  key :description, String
  key :hours_requested, String
  key :number_requested, String
  key :requirements, String
  key :population_served, String
  key :tags, Array, :default => []
  key :contact_name, String
  key :contact_email, String
  key :contact_phone, String
  key :status, String, :default => "active"
  key :search_terms, Array, :default => []
  belongs_to :service

  validates_presence_of :title, :description
  before_save :create_search_terms, :clean_tags

  def clean_tags

  end

  scope :search,  lambda { |term| where(:status => "active", :search_terms => cleaned_search_terms(term)) }
  scope :active, lambda { where(:status => "active") }

  def self.cleaned_search_terms(search_term)
    unless search_term.nil?
      return search_term.gsub(/\//, " ").gsub(PUNCTUATION, " ").downcase.split.uniq
    end
  end

  def create_search_terms
    self.search_terms = [contact_email, contact_name].delete_if(&:nil?).map(&:downcase)
    [title, description, requirements, tags, population_served].each do |term|
      next if term.nil?
      term = term.join(" ") if term.is_a? Array
      self.search_terms += term.gsub(/\//, " ").gsub(PUNCTUATION, "").downcase.split.uniq
    end
    self.search_terms.delete_if {|term| USELESS_TERMS.include? term}
    self.search_terms.delete_if(&:nil?)
    self.search_terms.delete_if(&:empty?)
    self.search_terms.uniq!
    #self.name_parts = title.gsub(/\//, " ").gsub(PUNCTUATION, "").downcase.split.uniq
    #self.name_parts.delete_if {|term| USELESS_TERMS.include? term}
  end

  def rank_search(search_term)
    @rank = 0
    search_array = search_term.gsub(PUNCTUATION, "").downcase.split.uniq
    search_rank_array =  search_array & search_terms.uniq
    @rank = search_rank_array.length
    if title =~ %r[#{search_term.strip}]i
      @rank = @rank * 3
    end
    if description =~ %r[#{search_term.strip}]i
      @rank = @rank * 3
    end
    @rank
  end

end
