require 'spec_helper'

describe "/recipes/edit.html.haml" do
  helper RecipesHelper
  
  before(:each) do
    log_in
    @recipe = Factory(:recipe)
    assign(:recipe, @recipe)
  end

  it "should render edit form" do
    render :file => "/recipes/edit.html.haml"
    
    rendered.should have_selector("form", :action => recipe_path(@recipe), :method => 'post') do |form|
      form.should have_selector("input#recipe_name",       :name => "recipe[name]")
      form.should have_selector("input#recipe_prep_time",  :name => "recipe[prep_time]")
      form.should have_selector("input#recipe_cook_time",  :name => "recipe[cook_time]")
      form.should have_selector("input#recipe_servings",   :name => "recipe[servings]")
      form.should have_selector("div#directions")
    end
  end
end


