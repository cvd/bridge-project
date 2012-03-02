Bridge.controllers :volunteer_opportunities do

  get :index do
    if params[:q].present?

      @query = params[:q]
      @route = "/search"
      session[:last_search] = request.url
      @title = params[:q] + " - The BRIDGE Project DC"
      paginate!

      @volunteer_opportunities = VolunteerOpportunity.active.search(@query).all

      @total_pages = @volunteer_opportunities.length/@per_page
      #need one more if there is a remainder
      @total_pages +=1 if @volunteer_opportunities.length % @per_page

      @volunteer_opportunities.each {|s| s.rank_search @query}
      @volunteer_opportunities.sort! {|a,b| b.rank <=> a.rank }
      @volunteer_opportunities = @volunteer_opportunities.slice!(@start..@end)

    else
      @volunteer_opportunities = VolunteerOpportunity.all
    end
    render "volunteer_opportunities/index"
  end

  get :new do
    @volunteer_opportunity = VolunteerOpportunity.new params[:volunteer_opportunity]
    render "volunteer_opportunities/new"
  end

  post :create do
    @volunteer_opportunity = VolunteerOpportunity.new(params[:volunteer_opportunity])
    if @volunteer_opportunity.service_id?
      @volunteer_opportunity.service = Service.find(@volunteer_opportunity.service_id)
    end
    if @volunteer_opportunity.save
      flash[:notice] = "New volunteer opportunity has been created and is awaiting approval"
      if @volunteer_opportunity.service?
        redirect url(:services, :show, :id => @volunteer_opportunity.service.id)
      else
        redirect url(:volunteer_opportunities, :show, :id => @volunteer_opportunity.id)
      end
    else
      render "volunteer_opportunities/new"
    end
  end

  get :edit, :with => :id do
    @opp = VolunteerOpportunity.find(params[:id])
  end

  post :update, :with => :id do
    @opp = VolunteerOpportunity.find(params[:id])
  end

  get :show, :with => :id do
    @opp = VolunteerOpportunity.find(params[:id])
    render "volunteer_opportunities/show"
  end

end
