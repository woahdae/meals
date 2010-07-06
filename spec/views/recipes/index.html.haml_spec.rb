require 'spec_helper'

describe "/recipes/index.html.haml" do
  helper RecipesHelper
  
  before(:each) do
    view.stub(:current_user_owns? => false)
    assign(:recipes, [ Factory(:recipe, :items => [Factory(:item)]), 
                          Factory(:recipe, :items => [Factory(:item)]) ])
  end

  it "should render list of recipes" do
    render :file => "/recipes/index.html.haml"
    rendered.should have_selector("div") {|div| div.should contain("Prep")}
    rendered.should have_selector("div.span-4.append-bottom") {|div| div.should contain("Example Recipe")}
  end
end

