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
  def show_breadcrumbs?
    !@index && @show_breadcrumbs != false
  end

  def breadcrumbs
    return "" if @index
    crumbs = ["<a href='/'>Home</a>"]
    if request.path =~ /search/i
      crumbs << "Search Results"
    end
    if request.path =~ /\/services\/show/ && session[:last_search]
      crumbs << "<a href='#{session[:last_search]}'>Search Results</a>"
      crumbs << "<span class='current'>#{@breadcrumb_title}</span>"
    end

    if request.path =~ /\/services\/new/
      crumbs << "Suggest a Service"
    end
    if request.path =~ /\/services\/service_types/
      crumbs << "Show Services by Type"
    end
    if request.path =~ /\/about/
      crumbs << "Mission Statement"
    end
    if request.path =~ /\/list_type/
      crumbs << "List Services by Type"
    end
    if request.path =~ /\/services\/update/
      crumbs << "Updating '#{@breadcrumb_title}'"
    end
    crumbs.join " :: "
  end

end
