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
    # @query = params[:q]
    # @page = params[:page] || 1
    # 
    # calc_page = @page.to_i - 1
    # @current_page = @page.to_i
    # @per_page = 10    
    # @start = calc_page * @per_page
    # @end = @start.to_i + @per_page - 1
    # 
    @query = params[:q]
    paginate!
    
    @services = Service.search(params[:q]).all#.paginate(:per_page => 25, :page => @page)
    
    @total_pages = @services.length/@per_page
    @total_pages +=1 if @services.length % @per_page

    @services.each {|s| s.rank_search @query}
    @services.sort! {|a,b|b.rank<=>a.rank}
    @services = @services.slice!(@start..@end)
    
    # result = Service.search(params[:q]).paginate(:per_page => 10, :page => @page)
    # @total_pages = result.total_pages
    
    if request.xhr?
      return result.to_json
    end
    render :"base/search_result", :layout => !request.xhr?
  end
  
  post :search, :map => "/search" do
    # @query = params[:q]
    # @page = params[:page] || 1
    # @page = @page.to_i
    # @current_page = @page
    # @per_page = 10    
    # @start = (@page - 1) * @per_page
    # @end = @start + @per_page - 1
    @query = params[:q]
    paginate!
    
    @services = Service.search(@query).all
    
    @total_pages = @services.length/@per_page
    #need one more if there is a remainder
    @total_pages +=1 if @services.length % @per_page

    @services.each {|s| s.rank_search @query}
    @services.sort! {|a,b|b.rank<=>a.rank}
    @services = @services.slice!(@start..@end)
    
    # result = Service.search(params[:q]).paginate(:per_page => 10, :page => @page)
    
    if request.xhr?
      return result.to_json
    end
    render :"base/search_result", :layout => !request.xhr?
  end
  
  
end