
get "/services/add" do 
  erb :"services/new"
end

post "/services/add" do 
  s = Service.new(params)
  s.save
  s.to_json
end

get "/services/edit/:id" do
  id = params[:id]
  service = Service.find(BSON::ObjectID(id))
  puts service.inspect
  erb :"services/edit", :locals => service
end

post "/services/edit/:id" do
  
end