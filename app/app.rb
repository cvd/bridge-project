class Bridge < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers
  # reCAPTCHA
  # Public Key: 6LefFb0SAAAAAAS7GyGHvy_vHl8zTIicvIz48BLK
  # Private Key: 6LefFb0SAAAAAABLMU7v97r_c-oFNo6of5L8WZla
  use Rack::Recaptcha, :public_key => '6LefFb0SAAAAAAS7GyGHvy_vHl8zTIicvIz48BLK', :private_key => '6LefFb0SAAAAAABLMU7v97r_c-oFNo6of5L8WZla', :paths => '/services/new'
  helpers Rack::Recaptcha::Helpers
  ##
  # Application configuration options
  #
  # set :raise_errors, true     # Show exceptions (default for development)
  # set :public, "foo/bar"      # Location for static assets (default root/public)
  # set :reload, false          # Reload application files (default in development)
  # set :default_builder, "foo" # Set a custom form builder (default 'StandardFormBuilder')
  # set :locale_path, "bar"     # Set path for I18n translations (defaults to app/locale/)
  enable  :sessions           # Disabled by default
  # disable :flash              # Disables rack-flash (enabled by default if sessions)
  # layout  :my_layout          # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
  #

  ##
  # You can configure for a specified environment like:
  #
  #   configure :development do
  #     set :foo, :bar
  #     disable :asset_stamp # no asset timestamping for dev
  #   end
  #

  ##
  # You can manage errors like:
  #
    error 404 do
      render :"errors/404"
    end
    error do 
      render :"errors/error"
    end
    
  #
end