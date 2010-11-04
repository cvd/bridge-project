Bridge.controllers :carts do
  get :add do
    @cart = Cart.find(BSON.ObjectId(session[:cart].to_s)) if session[:cart]
    if @cart.nil?
      @cart = Cart.new
      session[:cart] = @cart.id.to_s
    end
    @cart.collected_services << params[:service] unless @cart.collected_services.include? params[:service]
    return { :success => @cart.save, :cart => @cart.collected_services }.to_json    
  end
  
  post :clear do
    session[:cart] = nil
    return {:cleared => true}.to_json
  end
  
  get :show do 
    @cart = Cart.find(BSON::ObjectId(session[:cart].to_s))
    service_ids = @cart.collected_services
    @services = Service.find(service_ids)
    @print = true
    @title = "Print Saved Services - The BRIDGE Project DC"
    render :"services/cart", :layout => :"layouts/print"
  end
  
  post :remove do
    id = params[:id]
    @cart = Cart.find(BSON::ObjectId(session[:cart].to_s))
    @cart.collected_services.delete_if {|a| a == id.to_s } 
    @cart.save
    return {:success => true}.to_json
  end
  
end