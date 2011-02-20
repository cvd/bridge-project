
Bridge.controllers :services do
  get :show, :with => :id do    
    service = Service.find(BSON::ObjectId(params[:id]))
    @title = service.site_name + " - The BRIDGE Project DC"
    erb :"services/show", :locals => {:service => service, :show_map => true}
  end

  get :update, :with => :id do
    @service = Service.find(BSON::ObjectId(params[:id]))
    @title = @service.site_name + " - The BRIDGE Project DC"
    erb :"services/update", :locals => {:service => @service, :show_map => true}
  end

  put :update, :with => :id do
    @service = Service.new(params["service"])
    puts params.inspect
    @service.parent_service = params[:id]
    @service.save
    @title = @service.site_name + " - The BRIDGE Project DC"
    erb :"services/updated", :locals => {:service => @service}
  end

  get :advanced_search do
    params[:service].delete_if {|k,v| v.empty?}
    # ap request.methods.sort
    @request_string =  request.query_string
    query_string_parts = []
    params[:service].each do |k,v|
      value = v.is_a?(Array) ? v = v.map(&:downcase).join(", ") : v
      query_string_parts << "#{k.to_s.capitalize}: #{value}"
    end
    @query_string = query_string_parts.join(", ")

    if params[:service][:name]
      params[:service][:name_parts] = params[:service][:name].gsub(Service::PUNCTUATION, " ").downcase.split.uniq#.map(&strip)
      params[:service].delete('name')
    end
    paginate!
    @services = Service.where(params[:service]).paginate(:per_page => @per_page, :page => @page)

    @total_pages = @services.total_pages
    @current_page = @services.current_page
    @title = @query_string + " - The BRIDGE Project DC"

    render :"services/advanced_result"
  end

  get :service_types do
    service_types = Service.service_types
    @title = "List Services by type - The BRIDGE Project DC"
    if request.xhr?
      content_type :json
      return service_types.to_json
    else
      erb :"services/types", :locals => {:service_types => service_types}    
    end
  end

  get :list, :map => "/list_type/?" do
    if params[:q] && params[:type].nil?
      params[:type] = params[:q]
    end
    @title = "List Services by type: #{params[:type]} - The BRIDGE Project DC"
    paginate!
    @services = Service.where(:services => params[:type].downcase, :status => "active").paginate(:per_page => @per_page, :page => @page)
    @route = "/list_type"
    @query = params[:type]
    logger.info(@query)
    @total_pages = @services.total_pages
    @current_page = @services.current_page
    render :"services/result"
  end

  get :search, :map => "/search" do
    @query = params[:q]
    @route = "/search"
    paginate!

    @services = Service.search(params[:q]).all

    @total_pages = @services.length/@per_page
    @total_pages +=1 if @services.length % @per_page

    @services.each {|s| s.rank_search @query}
    @services.sort! {|a,b| b.rank <=> a.rank }
    @services = @services.slice!(@start..@end)

    if request.xhr?
      return result.to_json
    end
    render :"services/result", :layout => !request.xhr?
  end

  post :search, :map => "/search" do
    @query = params[:q]
    @route = "/search" 
    @title = params[:q] + " - The BRIDGE Project DC"
    paginate!

    @services = Service.search(@query).all

    @total_pages = @services.length/@per_page
    #need one more if there is a remainder
    @total_pages +=1 if @services.length % @per_page

    @services.each {|s| s.rank_search @query}
    @services.sort! {|a,b| b.rank <=> a.rank }
    @services = @services.slice!(@start..@end)

    if request.xhr?
      return result.to_json
    end
    render :"services/result", :layout => !request.xhr?
  end

  get :new do
    @service = Service.new
    render "services/new"
  end

  post :create do
    @service = Service.new(params[:service])
    if @service.save
      render :"services/added"
    else
      flash[:notice] = "Error Saving Service!"
      render :"services/new"
    end
  end

end
