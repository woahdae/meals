require 'spec_helper'

describe ListsController do
  it "should generate params for #show" do
    {:get => "/lists/1"}.should route_to(:controller => "lists", :action => "show", :id => "1")
  end

  it "should generate params for #destroy" do
    {:delete => "/lists/1"}.should route_to(:controller => "lists", :action => "destroy", :id => "1")
  end
end
