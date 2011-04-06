require 'spec_helper'

describe "services/show.html.erb" do
  before(:each) do
    @service = assign(:service, stub_model(Service,
      :site_name => "Site Name",
      :address => "Address",
      :city => "City",
      :state => "State",
      :zip => "Zip",
      :phone => "Phone",
      :hours => "Hours",
      :transportation => "Transportation"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Site Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Address/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/City/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/State/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Zip/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Phone/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Hours/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Transportation/)
  end
end
