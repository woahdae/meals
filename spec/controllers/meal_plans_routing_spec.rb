require 'spec_helper'

describe MealPlansController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "meal_plans", :action => "index").should == "/meal_plans"
    end
  
    it "should map #new" do
      route_for(:controller => "meal_plans", :action => "new").should == "/meal_plans/new"
    end
  
    it "should map #show" do
      route_for(:controller => "meal_plans", :action => "show", :id => "1").should == "/meal_plans/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "meal_plans", :action => "edit", :id => "1").should == "/meal_plans/1/edit"
    end
  
    # it "should map #update" do
    #   route_for(:controller => "meal_plans", :action => "update", :id => "1").should == "/meal_plans/1"
    # end
    #   
    # it "should map #destroy" do
    #   route_for(:controller => "meal_plans", :action => "destroy", :id => "1").should == "/meal_plans/1"
    # end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/meal_plans").should == {:controller => "meal_plans", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/meal_plans/new").should == {:controller => "meal_plans", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/meal_plans").should == {:controller => "meal_plans", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/meal_plans/1").should == {:controller => "meal_plans", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/meal_plans/1/edit").should == {:controller => "meal_plans", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/meal_plans/1").should == {:controller => "meal_plans", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/meal_plans/1").should == {:controller => "meal_plans", :action => "destroy", :id => "1"}
    end
  end
end
