require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "User Model" do
  it 'can be created' do
    @user = User.new
    @user.should.not.be.nil
  end
end
