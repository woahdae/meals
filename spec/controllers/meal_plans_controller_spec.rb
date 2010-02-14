require 'spec_helper'

describe MealPlansController do

  before(:each) do
    @meal_plan = Factory(:meal_plan)
  end

  describe "responding to GET index" do

    it "should expose all meal_plans as @meal_plans" do
      get :index
      assigns[:meal_plans].should == [@meal_plan]
    end

    describe "with mime type of xml" do
  
      it "should render all meal_plans as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        MealPlan.should_receive(:find).with(:all).and_return(meal_plans = mock("Array of MealPlans"))
        meal_plans.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested meal_plan as @meal_plan" do
      get :show, :id => @meal_plan.id
      assigns[:meal_plan].should == @meal_plan
    end
    
    describe "with mime type of xml" do

      it "should render the requested meal_plan as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        MealPlan.should_receive(:find).with("37").and_return(@meal_plan)
        @meal_plan.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new meal_plan as @meal_plan" do
      meal_plan = Factory.build(:meal_plan)
      MealPlan.should_receive(:new).and_return(meal_plan)
      get :new
      assigns[:meal_plan].should equal(meal_plan)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested meal_plan as @meal_plan" do
      get :edit, :id => @meal_plan.id
      assigns[:meal_plan].should == @meal_plan
    end

  end

  describe "responding to POST create" do

    before(:each) do
      @new_meal_plan = Factory.build(:meal_plan)
    end

    describe "with valid params" do

      it "should expose a newly created meal_plan as @meal_plan" do
        MealPlan.should_receive(:new).with({'these' => 'params'}).and_return(@new_meal_plan)
        post :create, :meal_plan => {:these => 'params'}
        assigns(:meal_plan).should equal(@new_meal_plan)
      end

      it "should redirect to the created meal_plan" do
        MealPlan.stub!(:new).and_return(@new_meal_plan)
        post :create, :meal_plan => {}
        response.should redirect_to(meal_plan_url(@new_meal_plan))
      end
      
    end
    
    describe "with invalid params" do

      before(:each) do
        @new_meal_plan.stub!(:save => false)
      end

      it "should expose a newly created but unsaved meal_plan as @meal_plan" do
        MealPlan.stub!(:new).with({'these' => 'params'}).and_return(@new_meal_plan)
        post :create, :meal_plan => {:these => 'params'}
        assigns(:meal_plan).should equal(@new_meal_plan)
      end

      it "should re-render the 'new' template" do
        MealPlan.stub!(:new).and_return(@new_meal_plan)
        post :create, :meal_plan => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT update" do

    before(:each) do
      MealPlan.should_receive(:find).with(@meal_plan.id.to_s).and_return(@meal_plan)
    end

    it "should update the requested meal_plan" do
      @meal_plan.should_receive(:update_attributes).with({'these' => 'params'})
      put :update, :id => @meal_plan.id, :meal_plan => {:these => 'params'}
    end

    describe "with valid params" do

      before(:each) do
        @meal_plan.stub!(:update_attributes => true)
      end

      it "should expose the requested meal_plan as @meal_plan" do
        put :update, :id => @meal_plan.id
        assigns(:meal_plan).should equal(@meal_plan)
      end

      it "should redirect to the meal_plan" do
        put :update, :id => @meal_plan.id
        response.should redirect_to(meal_plan_url(@meal_plan))
      end

    end
    
    describe "with invalid params" do

      before(:each) do
        @meal_plan.stub!(:update_attributes => false)
      end

      it "should expose the meal_plan as @meal_plan" do
        put :update, :id => @meal_plan.id
        assigns(:meal_plan).should equal(@meal_plan)
      end

      it "should re-render the 'edit' template" do
        put :update, :id => @meal_plan.id
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested meal_plan" do
      MealPlan.should_receive(:find).with(@meal_plan.id.to_s).and_return(@meal_plan)
      @meal_plan.should_receive(:destroy)
      delete :destroy, :id => @meal_plan.id
    end
  
    it "should redirect to the meal_plans list" do
      delete :destroy, :id => @meal_plan.id
      response.should redirect_to(meal_plans_url)
    end

  end

end
