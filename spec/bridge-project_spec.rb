require 'spec_helper'

# describe "BridgeProject" do
#   it "fails" do
#     should.flunk "hey buddy, you should probably rename this file and start specing for real"
#   end
# end


s = Service.where(:search_terms => ["Sample"]).all

puts s.inspect

puts