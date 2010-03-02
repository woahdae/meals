require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/lists/show.html.haml" do
  include ListsHelper
  
  before(:each) do
    assigns[:list] = @list = Factory(:list)
  end

  it "should render attributes in <p>" do
    render "/lists/show.html.haml"
  end
end

