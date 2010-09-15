Bridge.controllers :base do

  get :index, :map => "/" do
    render "base/index"
  end
  # get :_index, :map => "/s" do
  #   render "base/search_index"
  # end

  get :about, :map => '/about' do
    render "base/about"
  end
  
end