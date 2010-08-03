require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Account Model" do
  it 'can be created' do
    @account = Account.new
    @account.should.not.be.nil
  end
end
