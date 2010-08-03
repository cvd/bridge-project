Bridge.controllers :services do
  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get "/example" do
  #   "Hello world!"
  # end
  
  get :show, :with => :id do    
    service = Service.find(BSON::ObjectID(params[:id]))
    # logger.debug(service.inspect)
    erb :"services/show", :locals => {:service => service}
  end
  
  get :service_types do
    service_types = Service.service_types
    erb :"services/types", :locals => {:service_types => service_types}    
  end

  get :list, :with => :type do
    services = Service.where(:primary_type => params[:type])
    render "services/list", :locals => {:services => services}
  end
  
end