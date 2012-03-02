Admin.controllers :research_opportunities do

  get :index do
    @query = nil
    @page = params[:page] || 1
    @research_opportunities = ResearchOpportunity.active.sort(:site_name).paginate(:per_page => 25, :page => @page)
    @total_pages = @research_opportunities.total_pages
    @current_page = @research_opportunities.current_page
    @list_title = "All Research Opportunities"
    render 'research_opportunities/index'
  end

  get :modified do
    @view = :modified
    @query = nil
    @page = params[:page] || 1
    @research_opportunities = ResearchOpportunity.active.sort(:updated_at.desc).paginate(:per_page => 25, :page => @page)
    @total_pages = @research_opportunities.total_pages
    @current_page = @research_opportunities.current_page
    @list_title = "Most Recently Modified"    
    render 'research_opportunities/index'
  end

  get :search do

    @query = params[:q]
    @page = params[:page] || 1
    @page = @page.to_i
    @current_page = @page.to_i
    @per_page = 25
    @start = (@page-1) * @per_page
    @end = @start.to_i + @per_page - 1
    @research_opportunities = ResearchOpportunity.active.search(params[:q]).all#.paginate(:per_page => 25, :page => @page)

    @total_pages = @research_opportunities.length/@per_page
    @total_pages +=1 if @research_opportunities.length % @per_page

    @research_opportunities.each {|s| s.rank_search @query}
    @research_opportunities.sort! {|a,b|b.rank<=>a.rank}
    @research_opportunities = @research_opportunities.slice!(@start..@end)
    @list_title = "All Research Opportunities"    
    render 'research_opportunities/index'
  end

  get :new do
    @research_opportunity = ResearchOpportunity.new
    render 'research_opportunities/new'
  end

  get :selector do
    @research_opportunity = ResearchOpportunity.new
    @research_opportunity.research_opportunities += ["Child Care", "Advocacy"]
    render 'research_opportunities/selector'
  end

  get :pending do
    @page = params[:page] || 1
    @research_opportunities = ResearchOpportunity.where(:status => "pending").paginate(:per_page => 25, :page => @page)
    @total_pages = @research_opportunities.total_pages
    @current_page = @research_opportunities.current_page
    @route = :pending
    @list_title = "Pending Research Opportunities"
    render 'research_opportunities/pending'
  end

  get :updated do
    @page = params[:page] || 1
    @research_opportunities = ResearchOpportunity.where(:status => "updated").paginate(:per_page => 25, :page => @page)
    @total_pages = @research_opportunities.total_pages
    @current_page = @research_opportunities.current_page
    @route = :updated
    @list_title = "Updated Research Opportunities"    
    render 'research_opportunities/index'
  end

  post :activate, :with => :id do
    @research_opportunity = ResearchOpportunity.find(params[:id])
    @research_opportunity.status = "active"
    if @research_opportunity.save
      flash[:notice] = 'Research Opportunity was successfully accepted.'
      redirect url(:research_opportunities, :index)
    else
      render 'research_opportunities/edit'
    end
  end

  post :create do
    @research_opportunity = ResearchOpportunity.new(params[:research_opportunity])
    if @research_opportunity.save
      flash[:notice] = 'ResearchOpportunity was successfully created.'
      redirect url(:research_opportunities, :edit, :id => @research_opportunity.id)
    else
      render 'research_opportunities/new'
    end
  end

  get :edit, :with => :id do
    @research_opportunity = ResearchOpportunity.find(params[:id])
    if @research_opportunity.status == "updated"
      @old_research_opportunity = ResearchOpportunity.find(@research_opportunity.parent_research_opportunity)
      # puts @research_opportunity.parent_research_opportunity
      # puts @old_research_opportunity.inspect
      @old_research_opportunity = ResearchOpportunity.new if @old_research_opportunity.nil?
      render "research_opportunities/update"
    else
      render 'research_opportunities/edit'
    end
  end

  put :update, :with => :id do
    @research_opportunity = ResearchOpportunity.find(params[:id])
    if @research_opportunity.update_attributes(params[:research_opportunity])
      flash[:notice] = 'Research Opportunity was successfully updated.'
      redirect url(:research_opportunities, :edit, :id => @research_opportunity.id)
    else
      render 'research_opportunities/edit'
    end
  end

  put :update_modified, :with => :id do
    #may want to rework this flow a bit so as to not ruing links by removing the
    #old one and replacing with the new one. fine for now though...
    @research_opportunity = ResearchOpportunity.find(params[:id])
    if @research_opportunity.update_attributes(params[:research_opportunity])
      ResearchOpportunity.find(params[:research_opportunity][:parent_research_opportunity]).update_attributes(:status => "void")
      flash[:notice] = 'Research Opportunity was successfully updated.'
      redirect url(:research_opportunities, :edit, :id => @research_opportunity.id)
    else
      render 'research_opportunities/edit'
    end
  end
  delete :destroy, :with => :id do
    research_opportunity = ResearchOpportunity.find(params[:id])
    research_opportunity.destroy
    if research_opportunity.destroyed?
      flash[:notice] = 'Research Opportunity was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy ResearchOpportunity!'
    end
    redirect url(:research_opportunities, :index)
  end
end
