require 'spec_helper'

describe "/recipes/index.html.haml" do
  include RecipesHelper
  
  before(:each) do
    assigns[:recipes] = [ Factory(:recipe, :items => [Factory(:item)]), 
                          Factory(:recipe, :items => [Factory(:item)]) ]
  end

  it "should render list of recipes" do
    render "/recipes/index.html.haml"
    response.should have_tag("div", :text => /Prep/, :count => 1)
    response.should have_tag("div.span-4.append-bottom", :text => /Example\ Recipe/, :count => 2)
  end
end

