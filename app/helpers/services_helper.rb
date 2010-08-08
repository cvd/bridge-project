# Helper methods defined here can be accessed in any controller or view in the application

Bridge.helpers do
  def paginate!
    @page = params[:page] || 1
    @page = @page.to_i
    @current_page = @page
    @per_page = 10    
    @start = (@page - 1) * @per_page
    @end = @start + @per_page - 1
  end
end