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

  def query_string
     if @query_string
       @query_string.strip
     elsif @query
       @query.gsub(/\//, " ").gsub(Service::PUNCTUATION, " ").downcase.split.uniq.join(", ").strip
     else 
        ""
     end
  end

  def query_url
  end

  def printing?
    @print ||= false
  end

  def cart_items
    if session[:cart]
      return Cart.find(session[:cart]).collected_services
    end
    return []
  end

  def clear_old_sessions
    Cart.where(:updated_at.lt => (Time.now-24000)).map(&:delete)
  end

  def empty_cart?
    if session[:cart]
      @cart = Cart.find(session[:cart])
      if @cart.nil?
        session[:cart] = nil
        return true
      end
      return @cart.collected_services.empty?
    end
    return true
  end
end

