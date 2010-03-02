require 'spec_helper'

describe ListsController do
  describe "route generation" do
    it "should map #show" do
      route_for(:controller => "lists", :action => "show", :id => '1').should == "/lists/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "lists", :action => "destroy", :id => '1').should == { :path => "/lists/1", :method => :delete }
    end
  end

  describe "route recognition" do
    it "should generate params for #show" do
      params_from(:get, "/lists/1").should == {:controller => "lists", :action => "show", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/lists/1").should == {:controller => "lists", :action => "destroy", :id => "1"}
    end
  end
end
