require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ItemsController do

  def check_for_item_with_and_return(with, ret_val)
    Item.should_receive(:find) do |id, params|
      id.should == with
      params[:conditions].should == "\"items\".recipe_id = 1" if params
      ret_val
    end
  end

  before(:each) do
    @recipe = Factory(:recipe)
    Recipe.stub!(:find).and_return(@recipe)
    @item = Factory(:item, :recipe => @recipe)
  end

  describe "responding to GET index" do

    it "should expose all items as @items" do
      get :index
      assigns[:items].should == [@item]
    end

    describe "with mime type of xml" do
  
      it "should render all items as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        check_for_item_with_and_return(:all, items = mock("Array of Items"))
        items.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested item as @item" do
      get :show, :id => @item.id
      assigns[:item].should == @item
    end
    
    describe "with mime type of xml" do

      it "should render the requested item as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        check_for_item_with_and_return("37", @item)
        @item.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new item as @item" do
      item = Factory.build(:item)
      Item.should_receive(:new).and_return(item)
      get :new
      assigns[:item].should equal(item)
    end
    
    describe "with mime type of javascript" do
      
      it "should render the requested item as xml" do
        check_for_item_with_and_return(:all, items = mock("Array of Items"))
        xhr :get, :new
        response.body.should == "generated XML"
      end
      
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested item as @item" do
      get :edit, :id => @item.id
      assigns[:item].should == @item
    end

  end

  describe "responding to POST create" do

    before(:each) do
      @new_recipe = Factory.build(:recipe)
      @new_item = Factory.build(:item, :recipe => @new_recipe)
    end

    describe "with valid params" do

      it "should expose a newly created item as @item" do
        Item.should_receive(:new).with({'these' => 'params'}).and_return(@new_item)
        post :create, :item => {:these => 'params'}
        assigns(:item).should equal(@new_item)
      end

      it "should redirect to the created item" do
        Item.stub!(:new).and_return(@new_item)
        post :create, :item => {}
        response.should redirect_to(recipe_url(@new_recipe))
      end
      
    end
    
    describe "with invalid params" do

      before(:each) do
        @new_item.stub!(:save => false)
      end

      it "should expose a newly created but unsaved item as @item" do
        Item.stub!(:new).with({'these' => 'params'}).and_return(@new_item)
        post :create, :item => {:these => 'params'}
        assigns(:item).should equal(@new_item)
      end

      it "should re-render the 'new' template" do
        Item.stub!(:new).and_return(@new_item)
        post :create, :item => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT update" do

    before(:each) do
      check_for_item_with_and_return(@item.id.to_s, @item)
    end

    it "should update the requested item" do
      @item.should_receive(:update_attributes).with({'these' => 'params'})
      put :update, :id => @item.id, :item => {:these => 'params'}
    end

    describe "with valid params" do

      before(:each) do
        @item.stub!(:update_attributes => true)
      end

      it "should expose the requested item as @item" do
        put :update, :id => @item.id
        assigns(:item).should equal(@item)
      end

      it "should redirect to the item" do
        put :update, :id => @item.id
        response.should redirect_to(recipe_url(@item.recipe_id))
      end

    end
    
    describe "with invalid params" do

      before(:each) do
        @item.stub!(:update_attributes => false)
      end

      it "should expose the item as @item" do
        put :update, :id => @item.id
        assigns(:item).should equal(@item)
      end

      it "should re-render the 'edit' template" do
        put :update, :id => @item.id
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested item" do
      check_for_item_with_and_return(@item.id.to_s, @item)
      @item.should_receive(:destroy)
      delete :destroy, :id => @item.id
    end
  
    it "should redirect to the items list" do
      delete :destroy, :id => @item.id
      response.should redirect_to(recipe_url(@item.id))
    end

  end

end
