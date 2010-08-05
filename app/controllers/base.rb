Bridge.controllers :base do
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

  get :index, :map => "/" do
    render "base/index"
  end

  get :search, :map => "/search" do
    render "base/search"
  end
  
  post :search, :map => "/search" do
    logger.debug "in search"
    logger.debug "params: #{params.inspect}"
    result = Service.search(params[:q]).limit(10)
    if request.xhr?
      return result.to_json
    end
    render :"base/search_result", :locals => {:result => result}, :layout => true
  end
  
  
end