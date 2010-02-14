require 'spec_helper'

describe ReceiptsController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "receipts", :action => "index").should == "/receipts"
    end
  
    it "should map #new" do
      route_for(:controller => "receipts", :action => "new").should == "/receipts/new"
    end
  
    it "should map #show" do
      route_for(:controller => "receipts", :action => "show", :id => '1').should == "/receipts/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "receipts", :action => "edit", :id => '1').should == "/receipts/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "receipts", :action => "update", :id => '1').should == { :path => "/receipts/1", :method => :put }
    end
  
    it "should map #destroy" do
      route_for(:controller => "receipts", :action => "destroy", :id => '1').should == { :path => "/receipts/1", :method => :delete }
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/receipts").should == {:controller => "receipts", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/receipts/new").should == {:controller => "receipts", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/receipts").should == {:controller => "receipts", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/receipts/1").should == {:controller => "receipts", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/receipts/1/edit").should == {:controller => "receipts", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/receipts/1").should == {:controller => "receipts", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/receipts/1").should == {:controller => "receipts", :action => "destroy", :id => "1"}
    end
  end
end
