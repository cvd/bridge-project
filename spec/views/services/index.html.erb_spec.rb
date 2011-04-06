require 'spec_helper'

describe "services/index.html.erb" do
  before(:each) do
    assign(:services, [
      stub_model(Service,
        :site_name => "Site Name",
        :address => "Address",
        :city => "City",
        :state => "State",
        :zip => "Zip",
        :phone => "Phone",
        :hours => "Hours",
        :transportation => "Transportation"
      ),
      stub_model(Service,
        :site_name => "Site Name",
        :address => "Address",
        :city => "City",
        :state => "State",
        :zip => "Zip",
        :phone => "Phone",
        :hours => "Hours",
        :transportation => "Transportation"
      )
    ])
  end

  it "renders a list of services" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Site Name".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "City".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "State".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Zip".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Hours".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Transportation".to_s, :count => 2
  end
end
