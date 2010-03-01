require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FoodsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "foods", :action => "index").should == "/foods"
    end
  
    it "should map #new" do
      route_for(:controller => "foods", :action => "new").should == "/foods/new"
    end
  
    it "should map #show" do
      route_for(:controller => "foods", :action => "show", :id => '1').should == "/foods/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "foods", :action => "edit", :id => '1').should == "/foods/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "foods", :action => "update", :id => '1').should == { :path => "/foods/1", :method => :put }
    end
  
    it "should map #destroy" do
      route_for(:controller => "foods", :action => "destroy", :id => '1').should == { :path => "/foods/1", :method => :delete }
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/foods").should == {:controller => "foods", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/foods/new").should == {:controller => "foods", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/foods").should == {:controller => "foods", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/foods/1").should == {:controller => "foods", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/foods/1/edit").should == {:controller => "foods", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/foods/1").should == {:controller => "foods", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/foods/1").should == {:controller => "foods", :action => "destroy", :id => "1"}
    end
  end
end
