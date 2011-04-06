require "spec_helper"

describe ServicesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/services" }.should route_to(:controller => "services", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/services/new" }.should route_to(:controller => "services", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/services/1" }.should route_to(:controller => "services", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/services/1/edit" }.should route_to(:controller => "services", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/services" }.should route_to(:controller => "services", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/services/1" }.should route_to(:controller => "services", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/services/1" }.should route_to(:controller => "services", :action => "destroy", :id => "1")
    end

  end
end
