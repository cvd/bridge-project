Admin.controllers :volunteer_opportunities do

  get :index do
    @query = nil
    @page = params[:page] || 1
    @volunteer_opportunities = VolunteerOpportunity.active.sort(:site_name).paginate(:per_page => 25, :page => @page)
    @total_pages = @volunteer_opportunities.total_pages
    @current_page = @volunteer_opportunities.current_page
    @list_title = "All Volunteer Opportunities"
    render 'volunteer_opportunities/index'
  end

  get :modified do
    @view = :modified
    @query = nil
    @page = params[:page] || 1
    @volunteer_opportunities = VolunteerOpportunity.active.sort(:updated_at.desc).paginate(:per_page => 25, :page => @page)
    @total_pages = @volunteer_opportunities.total_pages
    @current_page = @volunteer_opportunities.current_page
    @list_title = "Most Recently Modified"    
    render 'volunteer_opportunities/index'
  end

  get :search do

    @query = params[:q]
    @page = params[:page] || 1
    @page = @page.to_i
    @current_page = @page.to_i
    @per_page = 25
    @start = (@page-1) * @per_page
    @end = @start.to_i + @per_page - 1
    @volunteer_opportunities = VolunteerOpportunity.active.search(params[:q]).all#.paginate(:per_page => 25, :page => @page)

    @total_pages = @volunteer_opportunities.length/@per_page
    @total_pages +=1 if @volunteer_opportunities.length % @per_page

    @volunteer_opportunities.each {|s| s.rank_search @query}
    @volunteer_opportunities.sort! {|a,b|b.rank<=>a.rank}
    @volunteer_opportunities = @volunteer_opportunities.slice!(@start..@end)
    @list_title = "All Volunteer Opportunities"    
    render 'volunteer_opportunities/index'
  end

  get :new do
    @volunteer_opportunity = VolunteerOpportunity.new
    render 'volunteer_opportunities/new'
  end

  get :selector do
    @volunteer_opportunity = VolunteerOpportunity.new
    @volunteer_opportunity.volunteer_opportunities += ["Child Care", "Advocacy"]
    render 'volunteer_opportunities/selector'
  end

  get :pending do
    @page = params[:page] || 1
    @volunteer_opportunities = VolunteerOpportunity.where(:status => "pending").paginate(:per_page => 25, :page => @page)
    @total_pages = @volunteer_opportunities.total_pages
    @current_page = @volunteer_opportunities.current_page
    @route = :pending
    @list_title = "Pending Volunteer Opportunities"
    render 'volunteer_opportunities/pending'
  end

  get :updated do
    @page = params[:page] || 1
    @volunteer_opportunities = VolunteerOpportunity.where(:status => "updated").paginate(:per_page => 25, :page => @page)
    @total_pages = @volunteer_opportunities.total_pages
    @current_page = @volunteer_opportunities.current_page
    @route = :updated
    @list_title = "Updated Volunteer Opportunities"    
    render 'volunteer_opportunities/index'
  end

  post :activate, :with => :id do
    @volunteer_opportunity = VolunteerOpportunity.find(params[:id])
    @volunteer_opportunity.status = "active"
    if @volunteer_opportunity.save
      flash[:notice] = 'Volunteer Opportunity was successfully accepted.'
      redirect url(:volunteer_opportunities, :index)
    else
      render 'volunteer_opportunities/edit'
    end
  end

  post :create do
    @volunteer_opportunity = VolunteerOpportunity.new(params[:volunteer_opportunity])
    if @volunteer_opportunity.save
      flash[:notice] = 'VolunteerOpportunity was successfully created.'
      redirect url(:volunteer_opportunities, :edit, :id => @volunteer_opportunity.id)
    else
      render 'volunteer_opportunities/new'
    end
  end

  get :edit, :with => :id do
    @volunteer_opportunity = VolunteerOpportunity.find(params[:id])
    @services = Service.active.order(:site_name).map {|s| [s.site_name, s.id] }
    @services.unshift(["",nil])
    if @volunteer_opportunity.status == "updated"
      @old_volunteer_opportunity = VolunteerOpportunity.find(@volunteer_opportunity.parent_volunteer_opportunity)
      # puts @volunteer_opportunity.parent_volunteer_opportunity
      # puts @old_volunteer_opportunity.inspect
      @old_volunteer_opportunity = VolunteerOpportunity.new if @old_volunteer_opportunity.nil?
      render "volunteer_opportunities/update"
    else
      render 'volunteer_opportunities/edit'
    end
  end

  put :update, :with => :id do
    @volunteer_opportunity = VolunteerOpportunity.find(params[:id])
    if @volunteer_opportunity.update_attributes(params[:volunteer_opportunity])
      flash[:notice] = 'Volunteer Opportunity was successfully updated.'
      redirect url(:volunteer_opportunities, :edit, :id => @volunteer_opportunity.id)
    else
      render 'volunteer_opportunities/edit'
    end
  end

  put :update_modified, :with => :id do
    #may want to rework this flow a bit so as to not ruing links by removing the
    #old one and replacing with the new one. fine for now though...
    @volunteer_opportunity = VolunteerOpportunity.find(params[:id])
    if @volunteer_opportunity.update_attributes(params[:volunteer_opportunity])
      VolunteerOpportunity.find(params[:volunteer_opportunity][:parent_volunteer_opportunity]).update_attributes(:status => "void")
      flash[:notice] = 'Volunteer Opportunity was successfully updated.'
      redirect url(:volunteer_opportunities, :edit, :id => @volunteer_opportunity.id)
    else
      render 'volunteer_opportunities/edit'
    end
  end
  delete :destroy, :with => :id do
    volunteer_opportunity = VolunteerOpportunity.find(params[:id])
    volunteer_opportunity.destroy
    if volunteer_opportunity.destroyed?
      flash[:notice] = 'Volunteer Opportunity was successfully destroyed.'
    else
      flash[:error] = 'Impossible destroy VolunteerOpportunity!'
    end
    redirect url(:volunteer_opportunities, :index)
  end
end
