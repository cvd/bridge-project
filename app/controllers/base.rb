Bridge.controllers :base do

  get :index, :map => "/" do
    @index = true
    render "base/index"
  end

  get :about, :map => '/about' do
    @title = "About - The BRIDGE Project DC"
    render "base/about"
  end
  
  get :clear_sessions, :map => "/clear_old_sessions" do
    if params[:key] == 'awesome_secret_key'
      clear_old_sessions
    end
  end
end
