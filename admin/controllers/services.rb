Admin.controllers :services do

  get :index do
    @query = nil
    @page = params[:page] || 1
    @services = Service.sort(:site_name).paginate(:per_page => 25, :page => @page)
    @total_pages = @services.total_pages
    @current_page = @services.current_page
    render 'services/index'
  end

  get :search do

    @query = params[:q]
    @page = params[:page] || 1
    @page = @page.to_i
    @current_page = @page.to_i
    @per_page = 25    
    @start = (@page-1) * @per_page
    @end = @start.to_i + @per_page - 1
    # paginate!
    @services = Service.search(params[:q]).all#.paginate(:per_page => 25, :page => @page)
    
    @total_pages = @services.length/@per_page
    @total_pages +=1 if @services.length % @per_page

    @services.each {|s| s.rank_search @query}
    @services.sort! {|a,b|b.rank<=>a.rank}
    @services = @services.slice!(@start..@end)
 
    render 'services/index'
  end


  get :new do
    @service = Service.new
    render 'services/new'
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
    render 'services/edit'
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