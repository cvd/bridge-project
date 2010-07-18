get "/accounts/index" do
  @accounts = Account.all
  puts @accounts.inspect
  erb :"accounts/index", :layout => false
end

# get "/new" do
#   @account = Account.new
#   render 'accounts/new'
# end
# 
# post "/create" do
#   @account = Account.new(params[:account])
#   if @account.save
#     flash[:notice] = 'Account was successfully created.'
#     redirect url(:accounts, :edit, :id => @account.id)
#   else
#     render 'accounts/new'
#   end
# end
# 
# get "/edit/:id"do
#   @account = Account.find(params[:id])
#   render 'accounts/edit'
# end
# 
# put "/update/:id" do
#   @account = Account.find(params[:id])
#   if @account.update_attributes(params[:account])
#     flash[:notice] = 'Account was successfully updated.'
#     redirect url(:accounts, :edit, :id => @account.id)
#   else
#     render 'accounts/edit'
#   end
# end
# 
# delete "/destroy/:id" do
#   account = Account.find(params[:id])
#   if account != current_account && account.destroy
#     flash[:notice] = 'Account was successfully destroyed.'
#   else
#     flash[:error] = 'Impossible destroy Account!'
#   end
#   redirect url(:accounts, :index)
# end