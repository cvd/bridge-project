require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "ServicesController" do
  it 'returns text at root' do
    get "/"
    last_response.body.should == "some text"
  end
end
