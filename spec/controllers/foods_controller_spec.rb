require 'spec_helper'

describe FoodsController do

  before(:each) do
    log_in
  end

  describe "responding to GET search_for_select" do

    before do
      @foods = [mock_model(Food, :name => "Noodles, raw")]
      FerretFood.stub(:search_by_name).with('Noodles').and_return(@foods)
    end

    context "with mime type of json" do

      it "should render the requested food as json" do
        pending
        request.env["HTTP_ACCEPT"] = "application/json"
        @foods.stub(:to_json).and_return("[generated JSON]")
        get :search_for_select, :name => "Noodles"
        response.body.should == "[generated JSON]"
      end

    end

    context "with mime type of javascript" do
      render_views
      it "should render the requested food as html to be inserted by the client" do
        request.env["HTTP_ACCEPT"] = "application/javascript"
        get :search_for_select, :name => "Noodles"
        response.body.should match(/<option.*?>Noodles, raw<\/option>/)
      end

    end

  end

  describe "responding to GET index" do

    before do
      @food = Factory.create(:food)
    end

    it "should expose all foods as @foods" do
      get :index
      assigns[:foods].should == [@food]
    end

    describe "with mime type of xml" do
  
      it "should render all foods as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Food.should_receive(:paginate).and_return(foods = mock("Array of Foods"))
        foods.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    before do
      @food = Factory.create(:food)
    end

    it "should expose the requested food as @food" do
      get :show, :id => @food.id
      assigns[:food].should == @food
    end
    
    describe "with mime type of xml" do

      it "should render the requested food as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Food.should_receive(:find).with("37").and_return(@food)
        @food.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new food as @food" do
      food = Factory.build(:food)
      Food.should_receive(:new).and_return(food)
      get :new
      assigns[:food].should equal(food)
    end

  end

  describe "responding to GET edit" do

    before do
      @food = Factory.create(:food)
    end

    it "should expose the requested food as @food" do
      get :edit, :id => @food.id
      assigns[:food].should == @food
    end

  end

  describe "responding to POST create" do

    before(:each) do
      @new_food = Factory.build(:food)
    end

    describe "with valid params" do

      it "should expose a newly created food as @food" do
        Food.should_receive(:new).\
          with({"source_id" => 1, "source_type" => "User", 'these' => 'params'}).
          and_return(@new_food)
        post :create, :food => {:these => 'params'}
        assigns(:food).should equal(@new_food)
      end

      it "should redirect to the created food" do
        Food.stub!(:new).and_return(@new_food)
        post :create, :food => {}
        response.should redirect_to(food_url(@new_food))
      end
      
    end
    
    describe "with invalid params" do

      before(:each) do
        @new_food.stub!(:save => false)
      end

      it "should expose a newly created but unsaved food as @food" do
        Food.should_receive(:new).\
          with({"source_id" => 1, "source_type" => "User", 'these' => 'params'}).
          and_return(@new_food)
        post :create, :food => {:these => 'params'}
        assigns(:food).should equal(@new_food)
      end

      it "should re-render the 'new' template" do
        Food.stub!(:new).and_return(@new_food)
        post :create, :food => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT update" do

    before do
      @food = Factory.create(:food)
    end

    before(:each) do
      Food.should_receive(:find).with(@food.id).and_return(@food)
    end

    it "should update the requested food" do
      @food.should_receive(:update_attributes).with({'these' => 'params'})
      put :update, :id => @food.id, :food => {:these => 'params'}
    end

    describe "with valid params" do

      before(:each) do
        @food.stub!(:update_attributes => true)
      end

      it "should expose the requested food as @food" do
        put :update, :id => @food.id
        assigns(:food).should equal(@food)
      end

      it "should redirect to the food" do
        put :update, :id => @food.id
        response.should redirect_to(food_url(@food))
      end

    end
    
    describe "with invalid params" do

      before(:each) do
        @food.stub!(:update_attributes => false)
      end

      it "should expose the food as @food" do
        put :update, :id => @food.id
        assigns(:food).should equal(@food)
      end

      it "should re-render the 'edit' template" do
        put :update, :id => @food.id
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    before do
      @food = Factory.create(:food)
    end

    it "should destroy the requested food" do
      Food.should_receive(:find).with(@food.id).and_return(@food)
      @food.should_receive(:destroy)
      delete :destroy, :id => @food.id
    end
  
    it "should redirect to the foods list" do
      delete :destroy, :id => @food.id
      response.should redirect_to(foods_url)
    end

  end

end
