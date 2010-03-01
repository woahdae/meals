require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/foods/index.html.haml" do
  include FoodsHelper
  
  before(:each) do
    assigns[:foods] = [ Factory(:food), Factory(:food) ]
  end

  it "should render list of foods" do
    render "/foods/index.html.haml"
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "1.5", 2)
  end
end

