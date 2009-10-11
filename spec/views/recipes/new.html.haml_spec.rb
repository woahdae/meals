require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/recipes/new.html.haml" do
  include RecipesHelper
  
  before(:each) do
    log_in
    assigns[:recipe] = Factory.build(:recipe)
    assigns[:items] = [ Factory.build(:item) ]
  end

  it "should render new form" do
    render "/recipes/new.html.haml"
    
    response.should have_tag("form[action=?][method=post]", recipes_path) do
      with_tag("input#recipe_name[name=?]", "recipe[name]")
      with_tag("input#recipe_prep_time[name=?]", "recipe[prep_time]")
      with_tag("input#recipe_cook_time[name=?]", "recipe[cook_time]")
      with_tag("input#recipe_servings[name=?]", "recipe[servings]")
      with_tag("textarea#recipe_directions[name=?]", "recipe[directions]")
    end
  end
end


