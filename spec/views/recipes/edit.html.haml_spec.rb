require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/recipes/edit.html.haml" do
  include RecipesHelper
  
  before(:each) do
    assigns[:recipe] = @recipe = Factory(:recipe)
  end

  it "should render edit form" do
    render "/recipes/edit.html.haml"
    
    response.should have_tag("form[action=#{recipe_path(@recipe)}][method=post]") do
      with_tag('input#recipe_name[name=?]', "recipe[name]")
      with_tag('input#recipe_prep_time[name=?]', "recipe[prep_time]")
      with_tag('input#recipe_cook_time[name=?]', "recipe[cook_time]")
      with_tag('input#recipe_servings[name=?]', "recipe[servings]")
      with_tag('textarea#recipe_directions[name=?]', "recipe[directions]")
    end
  end
end


