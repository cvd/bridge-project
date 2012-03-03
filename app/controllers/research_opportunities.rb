Bridge.controllers :research_opportunities do

  get :index do
    if params[:q].present?

      @query = params[:q]
      @route = "/search"
      session[:last_search] = request.url
      @title = params[:q] + " - The BRIDGE Project DC"
      paginate!

      @research_opportunities = ResearchOpportunity.active.search(@query).all

      @total_pages = @research_opportunities.length/@per_page
      #need one more if there is a remainder
      @total_pages +=1 if @research_opportunities.length % @per_page

      @research_opportunities.each {|s| s.rank_search @query}
      @research_opportunities.sort! {|a,b| b.rank <=> a.rank }
      @research_opportunities = @research_opportunities.slice!(@start..@end)

    else
      @research_opportunities = ResearchOpportunity.active.all
    end
    render "research_opportunities/index"
  end

  get :new do
    @research_opportunity = ResearchOpportunity.new params[:research_opportunity]
    render "research_opportunities/new"
  end

  post :create do
    @research_opportunity = ResearchOpportunity.new(params[:research_opportunity])
    if @research_opportunity.service_id?
      @research_opportunity.service = Service.find(@research_opportunity.service_id)
    end
    if @research_opportunity.save
      flash[:notice] = "new research opportunity has been created and is awaiting  approval"
      if @research_opportunity.service?
        redirect url(:services, :show, :id => @research_opportunity.service.id)
      else
        redirect url(:research_opportunities, :show, :id => @research_opportunity.id)
      end
    else
      render "research_opportunities/new"
    end
  end

  get :edit, :with => :id do
    @opp = ResearchOpportunity.find(params[:id])
  end

  post :update, :with => :id do
    @opp = ResearchOpportunity.find(params[:id])
  end

  get :show, :with => :id do
    @opp = ResearchOpportunity.find(params[:id])
    render "research_opportunities/show"
  end

end
