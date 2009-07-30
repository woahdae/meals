require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/items/index.html.haml" do
  include ItemsHelper
  
  before(:each) do
    assigns[:recipe] = Factory(:recipe)
    assigns[:items] = [ Factory(:item), Factory(:item) ]
  end

  it "should render list of items" do
    render "/items/index.html.haml"
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "value for amount", 2)
    response.should have_tag("tr>td", "9.99", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "1.5", 2)
  end
end

