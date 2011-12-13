Bridge.controllers :base do

  get :index, :map => "/" do
    @index = true
    render "base/index"
  end

  get :advanced_search do
    render "services/advanced_search"
  end

  get :about, :map => '/about' do
    @title = "About - The BRIDGE Project DC"
    render "base/about"
  end
  
  get :human_services, :map => "/human_services" do
    @title = "The George Washington University- Human Services Program"
    @show_breadcrumbs = false
    render "base/human_services"
  end

  get :jes, :map => "/jes" do
    @title = "University of Maryand- Jes Koepfler, PhD Candidate, iSchool"
    @show_breadcrumbs = false
    render "base/jes"
  end

  get :au, :map => "/au" do
    @title = 'American University- Localizing Peace Initiative'
    @show_breadcrumbs = false
    render "base/au"
  end

  get :partner, :map => "/partner" do
    @title = "Become a Partner!"
    @show_breadcrumbs = false
    render "base/partner"
  end
  
  get :clear_sessions, :map => "/clear_old_sessions" do
    if params[:key] == 'awesome_secret_key'
      clear_old_sessions
    end
  end
end
