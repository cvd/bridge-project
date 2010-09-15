require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

Service.collection.remove

describe "Service Model" do
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

  it 'can be created' do
    @service = Service.new
    @service.should.not.be.nil
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
  
  it "should save the primary_service and secondary_service in services array" do
    @params[:primary_service] = "Primary Service"
    @params[:secondary_service] = "Secondary Service"
    service = Service.new(@params)
    service.save
    service.services.should == ["primary service", "secondary service"]
  end

  it "should strip the primary_service and secondary_service of leading and trailing whitespace and line feeds on save" do
    @params[:primary_service] = "\nPrimary Service \n\n"
    @params[:secondary_service] = "\nSecondary Service \n\n"
    service = Service.new(@params)
    service.save
    service.primary_service.should == "Primary Service"
    service.secondary_service.should == "Secondary Service"    
  end
  
end