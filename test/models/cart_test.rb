require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Cart Model" do
  it 'can be created' do
    @cart = Cart.new
    @cart.should.not.be.nil
  end
end
