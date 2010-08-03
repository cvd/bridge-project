require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

Service.collection.remove

describe "Service Model" do
  it 'can be created' do
    @service = Service.new
    @service.should.not.be.nil
  end
end

describe "BridgeProject" do
  before do
    @params = {
      :site_name => "Sample Site",
      :address => "123 Awesome Drive",
      :city => "Washington",
      :state => "DC",
      :zip => 22209,
      :quadrant => "NW", 
      :description => "This site is a Sample Site where people come to sample things!"
    }

  end
    
  it "Should create search terms upon creeation" do
    @service = Service.new(@params)
    @service.save
    @service.search_terms.should.not.equal []
  end
  
  it "should find by search terms" do 
    result = Service.search('Sample Site').first
    result.should.not.be.nil
    result.should.not.equal []
    result.site_name.should.equal "Sample Site"
    result.quadrant.should.equal "NW"
  end
  
  it "should find it a service by quadrant" do
    Service.search("NW").first.quadrant.should.equal "NW"
  end
  
  it "should find Service by search terms" do 
    result = Service.search('Sample Site Banana').first
    result.should.not.be.nil
    result.should.not.equal []
    result.site_name.should.equal "Sample Site"
    result.quadrant.should.equal "NW"
  end
end



__END__

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