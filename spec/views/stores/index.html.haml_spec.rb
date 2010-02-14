require 'spec_helper'

describe "/stores/index.html.haml" do
  include StoresHelper
  
  before(:each) do
    assigns[:stores] = [ Factory(:store), Factory(:store) ]
  end

  it "should render list of stores" do
    render "/stores/index.html.haml"
    response.should have_tag("tr>td", "value for street", 2)
    response.should have_tag("tr>td", "value for state", 2)
    response.should have_tag("tr>td", "value for city", 2)
    response.should have_tag("tr>td", "value for zip", 2)
    response.should have_tag("tr>td", "value for name", 2)
  end
end

