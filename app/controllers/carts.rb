Bridge.controllers :carts do
  get :add do
    logger.debug("I made it!: #{session[:cart]}")
    @cart = Cart.find(BSON.ObjectId(params[:service]))
    if @cart.nil?
      @cart = Cart.new
      session[:cart] = @cart.id
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
  
end