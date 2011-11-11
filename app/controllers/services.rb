require 'fastercsv'
Bridge.controllers :services do
  get :show, :with => :id do
    begin
      service = Service.find(BSON::ObjectId(params[:id]))
      @title = service.site_name + " - The BRIDGE Project DC"
      @breadcrumb_title = service.site_name
      erb :"services/show", :locals => {:service => service, :show_map => true}
    rescue BSON::InvalidObjectId
      @message = "Service Not Found"
      return 404
    end
  end

  get :update, :with => :id do
    @service = Service.find(BSON::ObjectId(params[:id]))
    @title = @service.site_name + " - The BRIDGE Project DC"
    @breadcrumb_title = @service.site_name
    erb :"services/update", :locals => {:service => @service, :show_map => true}
  end

  put :update, :with => :id do
    @service = Service.new(params["service"])
    @service.parent_service = params[:id]
    if recaptcha_valid? and @service.save
      @title = @service.site_name + " - The BRIDGE Project DC"
      render :"services/updated", :locals => {:service => @service}
    else
      flash[:notice] = "Error Saving Service!"
      if !recaptcha_valid?
        @service.errors.add(:captcha, "Invalid Captcha Response")
      end
      render :"services/update", :locals => {:service => @service, :show_map => true}
    end

  end

  get :advanced_search do
    params[:service].delete_if {|k,v| v.empty?} unless params[:service].nil?
    @request_string =  request.query_string
    session[:last_search] = request.url
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
    @services = Service.active.where(params[:service]).paginate(:per_page => @per_page, :page => @page)

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
    session[:last_search] = request.url
    @title = "List Services by type: #{params[:type]} - The BRIDGE Project DC"
    paginate!
    @services = Service.active.where(:services => %r[#{params[:type].downcase}]i).paginate(:per_page => @per_page, :page => @page)
    @route = "/list_type"
    @query = params[:type]
    logger.info(@query)
    @query_string = "Service type: #{@query.capitalize}"
    @total_pages = @services.total_pages
    @current_page = @services.current_page
    render :"services/result"
  end

  get :search, :map => "/search" do
    @query = params[:q]
    @route = "/search"
    session[:last_search] = request.url
    @title = params[:q] + " - The BRIDGE Project DC"
    paginate!

    @services = Service.active.search(@query).all

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
    if recaptcha_valid? and @service.save
      render :"services/added"
    else
      flash[:notice] = "Error Saving Service!"
      if !recaptcha_valid?
        @service.errors.add(:captcha, "Invalid Captcha Response")
      end
      render :"services/new"
    end
  end

  get :map do
    render :"services/map", :layout => false
  end
  get :kml do
    @services = Service.active
    mime_type :kml
    render :"services/kml", :layout => false
  end

  get :export do
    reject = [
      'parent_service',
      'secondary_service',
      'name_parts',
      'search_terms',
      'primary_service',
      '_id'
    ]

    csv = FasterCSV.generate do |csv|
      attributes = Service.first.attributes.map {|k,v| k}
      attributes = attributes.reject {|c| reject.include?(c) }
      csv << attributes

      Service.active.each do |service|
        attrs = service.attributes.map {|k,v| v}
        csv << attributes.map do |attr|
          value = service.attributes[attr]
          if attr == 'services'
            value.join(", ")
          elsif
            value.is_a?(Time)
            value.strftime('%m/%d/%Y %I:%M %p')
          else
            value
          end
        end
      end
    end

    file = Tempfile.new("csv-export")
    file.write(csv)
    file.rewind
    send_file(file.path, :disposition => :attachment, :filename => "bridge_project_data.csv")
  end

  get :all do
    content_type :json
    Service.all.to_json(:only =>[:_id, :lat, :lng])
  end
end
