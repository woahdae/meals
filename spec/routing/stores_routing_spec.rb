require 'spec_helper'

describe StoresController do
  it "should generate params for #index" do
    {:get => "/stores"}.should route_to(:controller => "stores", :action => "index")
  end

  it "should generate params for #new" do
    {:get => "/stores/new"}.should route_to(:controller => "stores", :action => "new")
  end

  it "should generate params for #create" do
    {:post => "/stores"}.should route_to(:controller => "stores", :action => "create")
  end

  it "should generate params for #show" do
    {:get => "/stores/1"}.should route_to(:controller => "stores", :action => "show", :id => "1")
  end

  it "should generate params for #edit" do
    {:get => "/stores/1/edit"}.should route_to(:controller => "stores", :action => "edit", :id => "1")
  end

  it "should generate params for #update" do
    {:put => "/stores/1"}.should route_to(:controller => "stores", :action => "update", :id => "1")
  end

  it "should generate params for #destroy" do
    {:delete => "/stores/1"}.should route_to(:controller => "stores", :action => "destroy", :id => "1")
  end
end
