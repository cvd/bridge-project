Bridge.controllers :services do
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
  
  get :search, :map => "/search" do
    @query = params[:q]

    paginate!
    
    @services = Service.search(params[:q]).all
    
    @total_pages = @services.length/@per_page
    @total_pages +=1 if @services.length % @per_page

    @services.each {|s| s.rank_search @query}
    @services.sort! {|a,b|b.rank<=>a.rank}
    @services = @services.slice!(@start..@end)
    
    if request.xhr?
      return result.to_json
    end
    render :"base/search_result", :layout => !request.xhr?
  end
  
  post :search, :map => "/search" do
    @query = params[:q]
    paginate!
    
    @services = Service.search(@query).all
    
    @total_pages = @services.length/@per_page
    #need one more if there is a remainder
    @total_pages +=1 if @services.length % @per_page

    @services.each {|s| s.rank_search @query}
    @services.sort! {|a,b|b.rank<=>a.rank}
    @services = @services.slice!(@start..@end)
    
    if request.xhr?
      return result.to_json
    end
    render :"base/search_result", :layout => !request.xhr?
  end
  
  
end