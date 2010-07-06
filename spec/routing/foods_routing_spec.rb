require 'spec_helper'

describe FoodsController do
  it "should generate params for #index" do
    {:get => "/foods"}.should route_to(:controller => "foods", :action => "index")
  end

  it "should generate params for #new" do
    {:get => "/foods/new"}.should route_to(:controller => "foods", :action => "new")
  end

  it "should generate params for #create" do
    {:post => "/foods"}.should route_to(:controller => "foods", :action => "create")
  end

  it "should generate params for #show" do
    {:get => "/foods/1"}.should route_to(:controller => "foods", :action => "show", :id => "1")
  end

  it "should generate params for #edit" do
    {:get => "/foods/1/edit"}.should route_to(:controller => "foods", :action => "edit", :id => "1")
  end

  it "should generate params for #update" do
    {:put => "/foods/1"}.should route_to(:controller => "foods", :action => "update", :id => "1")
  end

  it "should generate params for #destroy" do
    {:delete => "/foods/1"}.should route_to(:controller => "foods", :action => "destroy", :id => "1")
  end
end
