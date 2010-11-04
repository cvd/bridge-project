Bridge.controllers :base do

  get :index, :map => "/" do
    render "base/index"
  end

  get :about, :map => '/about' do
    @title = "About - The BRIDGE Project DC"
    render "base/about"
  end
  
end