class Admin < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl

  ##
  # Application configuration options
  #
  set :raise_errors, false     # Show exceptions (default for development)
  # set :public, "foo/bar"      # Location for static assets (default root/public)
  # set :reload, false          # Reload application files (default in development)
  # set :default_builder, "foo" # Set a custom form builder (default 'StandardFormBuilder')
  # set :locale_path, "bar"     # Set path for I18n translations (default your_app/locales)
  enable  :sessions           # Disabled by default
  # disable :flash              # Disables rack-flash (enabled by default if sessions)
  # layout  :my_layout          # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
  disable :show_exceptions

  set :login_page, "/admin/sessions/new"
  disable :store_location

  access_control.roles_for :any do |role|
    role.protect "/"
    role.allow "/sessions"
  end

  access_control.roles_for :admin do |role|
      role.project_module :services, "/services"
      role.project_module :research_opportunities, "/research_opportunities"      
      role.project_module :volunteer_opportunities, "/volunteer_opportunities"      
      role.project_module :accounts, "/accounts"
  end
  error 404 do
    puts "message: #{@message}"
    render :"errors/404"
  end
  error 500 do
    render :"errors/error"
  end
end
