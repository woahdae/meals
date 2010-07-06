require 'spec_helper'

describe RecipesController do
  it "should generate params for #index" do
    {:get => "/recipes"}.should route_to(:controller => "recipes", :action => "index")
  end

  it "should generate params for #new" do
    {:get => "/recipes/new"}.should route_to(:controller => "recipes", :action => "new")
  end

  it "should generate params for #create" do
    {:post => "/recipes"}.should route_to(:controller => "recipes", :action => "create")
  end

  it "should generate params for #show" do
    {:get => "/recipes/1"}.should route_to(:controller => "recipes", :action => "show", :id => "1")
  end

  it "should generate params for #edit" do
    {:get => "/recipes/1/edit"}.should route_to(:controller => "recipes", :action => "edit", :id => "1")
  end

  it "should generate params for #update" do
    {:put => "/recipes/1"}.should route_to(:controller => "recipes", :action => "update", :id => "1")
  end

  it "should generate params for #destroy" do
    {:delete => "/recipes/1"}.should route_to(:controller => "recipes", :action => "destroy", :id => "1")
  end
end
