require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/recipes/index.html.haml" do
  include RecipesHelper
  
  before(:each) do
    assigns[:recipes] = [ Factory(:recipe), Factory(:recipe) ]
  end

  it "should render list of recipes" do
    render "/recipes/index.html.haml"
    response.should have_tag("div", :text => /Prep/, :count => 1)
    response.should have_tag("div.span-4.clear.append-bottom", :text => /value for name/, :count => 2)
  end
end

