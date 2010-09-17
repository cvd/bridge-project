Bridge.controllers :carts do
  get :add do
    logger.debug("I made it!: #{session[:cart]}")
    @cart = Cart.find(BSON.ObjectId(session[:cart].to_s))
    if @cart.nil?
      @cart = Cart.new
      session[:cart] = @cart.id.to_s
    end
    logger.info("Cart: #{@cart.inspect}")
    @cart.collected_services << params[:service]
    logger.debug(@cart.inspect)
    return { :success => @cart.save, :cart => session[:cart] }.to_json    
  end
  
  post :clear do
    @cart = Cart.find(BSON::ObjectID(session[:cart]))
    @cart.collected_services = []
    return {:success => @cart.save, :cart => session[:cart]}.to_json
  end
  
  get :show do 
    @cart = Cart.find(BSON::ObjectId(session[:cart].to_s))
    puts @cart.inspect
    service_ids = @cart.collected_services
    if service_ids.length > 0
      @services = Service.find(service_ids)
    end
    
    render :"services/cart"
  end
  
end