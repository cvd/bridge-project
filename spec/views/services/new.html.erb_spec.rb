require 'spec_helper'

describe "services/new.html.erb" do
  before(:each) do
    assign(:service, stub_model(Service,
      :site_name => "MyString",
      :address => "MyString",
      :city => "MyString",
      :state => "MyString",
      :zip => "MyString",
      :phone => "MyString",
      :hours => "MyString",
      :transportation => "MyString"
    ).as_new_record)
  end

  it "renders new service form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => services_path, :method => "post" do
      assert_select "input#service_site_name", :name => "service[site_name]"
      assert_select "input#service_address", :name => "service[address]"
      assert_select "input#service_city", :name => "service[city]"
      assert_select "input#service_state", :name => "service[state]"
      assert_select "input#service_zip", :name => "service[zip]"
      assert_select "input#service_phone", :name => "service[phone]"
      assert_select "input#service_hours", :name => "service[hours]"
      assert_select "input#service_transportation", :name => "service[transportation]"
    end
  end
end
