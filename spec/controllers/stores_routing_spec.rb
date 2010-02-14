require 'spec_helper'

describe StoresController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "stores", :action => "index").should == "/stores"
    end
  
    it "should map #new" do
      route_for(:controller => "stores", :action => "new").should == "/stores/new"
    end
  
    it "should map #show" do
      route_for(:controller => "stores", :action => "show", :id => '1').should == "/stores/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "stores", :action => "edit", :id => '1').should == "/stores/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "stores", :action => "update", :id => '1').should == { :path => "/stores/1", :method => :put }
    end
  
    it "should map #destroy" do
      route_for(:controller => "stores", :action => "destroy", :id => '1').should == { :path => "/stores/1", :method => :delete }
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/stores").should == {:controller => "stores", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/stores/new").should == {:controller => "stores", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/stores").should == {:controller => "stores", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/stores/1").should == {:controller => "stores", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/stores/1/edit").should == {:controller => "stores", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/stores/1").should == {:controller => "stores", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/stores/1").should == {:controller => "stores", :action => "destroy", :id => "1"}
    end
  end
end
