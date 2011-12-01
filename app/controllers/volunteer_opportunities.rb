Bridge.controllers :volunteer_opportunities do

  get :index do
    @volunteer_opportunities = VolunteerOpportunity.all
    render "volunteer_opportunities/index"
  end

  get :new do
    @volunteer_opportunity = VolunteerOpportunity.new
    render "volunteer_opportunities/new"
  end

  post :create do

  end

  get :edit, :with => :id do

  end

  post :update, :with => :id do

  end

  get :show, :with => :id do

  end

end
