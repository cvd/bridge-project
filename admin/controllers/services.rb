Admin.controllers :services do

  get :index do
    @query = nil
    @page = params[:page] || 1
    @services = Service.sort(:site_name).paginate(:per_page => 25, :page => @page)
    @total_pages = @services.total_pages
    @current_page = @services.current_page
    render 'services/index', :locals => {:list_title => "All Services"}
  end

  get :search do

    @query = params[:q]
    @page = params[:page] || 1
    @page = @page.to_i
    @current_page = @page.to_i
    @per_page = 25
    @start = (@page-1) * @per_page
    @end = @start.to_i + @per_page - 1
    @services = Service.search(params[:q]).all#.paginate(:per_page => 25, :page => @page)

    @total_pages = @services.length/@per_page
    @total_pages +=1 if @services.length % @per_page

    @services.each {|s| s.rank_search @query}
    @services.sort! {|a,b|b.rank<=>a.rank}
    @services = @services.slice!(@start..@end)

    render 'services/index', :locals => {:list_title => "All Services"}
  end

  get :type do
    @type = params[:service].downcase
    @services = Service.where(:services => @type)
    render 'services/type'
  end

  get :new do
    @service = Service.new
    render 'services/new'
  end

  get :selector do
    @service = Service.new
    @service.services += ["Child Care", "Advocacy"]
    render 'services/selector'
  end

  get :pending do
    @page = params[:page] || 1
    @services = Service.where(:status => "pending").paginate(:per_page => 25, :page => @page)
    @total_pages = @services.total_pages
    @current_page = @services.current_page
    @route = :pending
    render 'services/index', :locals => {:list_title => "Pending Services"}
  end

  get :updated do
    @page = params[:page] || 1
    @services = Service.where(:status => "updated").paginate(:per_page => 25, :page => @page)
    @total_pages = @services.total_pages
    @current_page = @services.current_page
    @route = :updated
    render 'services/index', :locals => {:list_title => "Updated Services"}
  end

  post :activate, :with => :id do
    @service = Service.find(params[:id])
    @service.status = "active"
    if @service.save
      flash[:notice] = 'Service was successfully accepted.'
      redirect url(:services, :index)
    else
      render 'services/edit'
    end
  end

  post :create do
    @service = Service.new(params[:service])
    if @service.save
      flash[:notice] = 'Service was successfully created.'
      redirect url(:services, :edit, :id => @service.id)
    else
      render 'services/new'
    end
  end

  get :edit, :with => :id do
    @service = Service.find(params[:id])
    if @service.status == "updated"
      @old_service = Service.find(@service.parent_service)
      # puts @service.parent_service
      # puts @old_service.inspect
      @old_service = Service.new if @old_service.nil?
      render "services/update"
    else
      render 'services/edit'
    end
  end

  put :update, :with => :id do
    @service = Service.find(params[:id])
    if @service.update_attributes(params[:service])
      flash[:notice] = 'Service was successfully updated.'
      redirect url(:services, :edit, :id => @service.id)
    else
      render 'services/edit'
    end
  end

  put :update_modified, :with => :id do
    #may want to rework this flow a bit so as to not ruing links by removing the
    #old one and replacing with the new one. fine for now though...
    @service = Service.find(params[:id])
    if @service.update_attributes(params[:service])
      Service.find(params[:service][:parent_service]).update_attributes(:status => "void")
      flash[:notice] = 'Service was successfully updated.'
      redirect url(:services, :edit, :id => @service.id)
    else
      render 'services/edit'
    end
  end
  delete :destroy, :with => :id do
    service = Service.find(params[:id])
    service.destroy
    if service.destroyed?
      flash[:notice] = 'Service was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy Service!'
    end
    redirect url(:services, :index)
  end
end
