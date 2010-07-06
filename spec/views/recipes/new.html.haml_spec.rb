require 'spec_helper'

describe "/recipes/new.html.haml" do
  helper RecipesHelper
  
  before(:each) do
    log_in
    assign(:recipe, Factory.build(:recipe))
    assign(:items, [ Factory.build(:item) ])
  end

  it "should render new form" do
    render :file => "/recipes/new.html.haml"
    
    rendered.should have_selector("form", :action => recipes_path, :method => "post") do |form|
      form.should have_selector("input#recipe_name",       :name => "recipe[name]")
      form.should have_selector("input#recipe_prep_time",  :name => "recipe[prep_time]")
      form.should have_selector("input#recipe_cook_time",  :name => "recipe[cook_time]")
      form.should have_selector("input#recipe_servings",   :name => "recipe[servings]")
      form.should have_selector("div#directions")
    end
  end
end


