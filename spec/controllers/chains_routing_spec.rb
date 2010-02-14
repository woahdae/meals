require 'spec_helper'

describe ChainsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "chains", :action => "index").should == "/chains"
    end
  
    it "should map #new" do
      route_for(:controller => "chains", :action => "new").should == "/chains/new"
    end
  
    it "should map #show" do
      route_for(:controller => "chains", :action => "show", :id => '1').should == "/chains/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "chains", :action => "edit", :id => '1').should == "/chains/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "chains", :action => "update", :id => '1').should == { :path => "/chains/1", :method => :put }
    end
  
    it "should map #destroy" do
      route_for(:controller => "chains", :action => "destroy", :id => '1').should == { :path => "/chains/1", :method => :delete }
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/chains").should == {:controller => "chains", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/chains/new").should == {:controller => "chains", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/chains").should == {:controller => "chains", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/chains/1").should == {:controller => "chains", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/chains/1/edit").should == {:controller => "chains", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/chains/1").should == {:controller => "chains", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/chains/1").should == {:controller => "chains", :action => "destroy", :id => "1"}
    end
  end
end
