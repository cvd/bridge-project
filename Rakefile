require 'rake'
desc "Clear old sessions"

task :clear_sessions do 
  ENV["RACK_ENV"] = "production"
  require "./config/boot.rb"
  # delete Sessions that are at least 4 hours old.
  t = Time.now - (7200*2)
  Cart.where(:updated_at.lt => t).each &:delete
end

task :seed_data do
  
  %x[(cd data  && gunzip < seeds.tar.gz | tar xvf - && mongorestore -d test_db ./bridge_production && rm -rf bridge_production)]
end

