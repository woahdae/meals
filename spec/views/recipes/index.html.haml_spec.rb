require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/recipes/index.html.haml" do
  include RecipesHelper
  
  before(:each) do
    assigns[:recipes] = [ Factory(:recipe), Factory(:recipe) ]
  end

  it "should render list of recipes" do
    render "/recipes/index.html.haml"
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "1.5", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "value for directions", 2)
  end
end

