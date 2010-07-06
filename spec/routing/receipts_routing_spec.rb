require 'spec_helper'

describe ReceiptsController do
  it "should generate params for #index" do
    {:get => "/receipts"}.should route_to(:controller => "receipts", :action => "index")
  end

  it "should generate params for #new" do
    {:get => "/receipts/new"}.should route_to(:controller => "receipts", :action => "new")
  end

  it "should generate params for #create" do
    {:post => "/receipts"}.should route_to(:controller => "receipts", :action => "create")
  end

  it "should generate params for #show" do
    {:get => "/receipts/1"}.should route_to(:controller => "receipts", :action => "show", :id => "1")
  end

  it "should generate params for #edit" do
    {:get => "/receipts/1/edit"}.should route_to(:controller => "receipts", :action => "edit", :id => "1")
  end

  it "should generate params for #update" do
    {:put => "/receipts/1"}.should route_to(:controller => "receipts", :action => "update", :id => "1")
  end

  it "should generate params for #destroy" do
    {:delete => "/receipts/1"}.should route_to(:controller => "receipts", :action => "destroy", :id => "1")
  end
end
