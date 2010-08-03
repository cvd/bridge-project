require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'bridge-project'



me = {:name => "Colin", 
      :surname => "Van Dyke", 
      :email => "vandyke.colin@gmail.com", 
      :role => "Admin", 
      :password => "test", 
      :password_confirmation => "test"}

a = Account.new(me)

a.save

puts a.inspect
