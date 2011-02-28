require 'rake'
desc "Clear old sessions"

task :clear_sessions do 
  ENV["RACK_ENV"] = "production"
  require "./config/boot.rb"
  # delete Sessions that are at least 4 hours old.
  t = Time.now - (7200*2)
  Cart.where(:updated_at.lt => t).each &:delete
end

