require 'spec_helper'

describe StoresController do

  before(:each) do
    @store = Factory(:store)
  end

  describe "responding to GET index" do

    it "should expose all stores as @stores" do
      get :index
      assigns[:stores].should == [@store]
    end

    describe "with mime type of xml" do
  
      it "should render all stores as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Store.should_receive(:find).with(:all).and_return(stores = mock("Array of Stores"))
        stores.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested store as @store" do
      get :show, :id => @store.id
      assigns[:store].should == @store
    end
    
    describe "with mime type of xml" do

      it "should render the requested store as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Store.should_receive(:find).with("37").and_return(@store)
        @store.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new store as @store" do
      store = Factory.build(:store)
      Store.should_receive(:new).and_return(store)
      get :new
      assigns[:store].should equal(store)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested store as @store" do
      get :edit, :id => @store.id
      assigns[:store].should == @store
    end

  end

  describe "responding to POST create" do

    before(:each) do
      @new_store = Factory.build(:store)
    end

    describe "with valid params" do

      it "should expose a newly created store as @store" do
        Store.should_receive(:new).with({'these' => 'params'}).and_return(@new_store)
        post :create, :store => {:these => 'params'}
        assigns(:store).should equal(@new_store)
      end

      it "should redirect to the created store" do
        Store.stub!(:new).and_return(@new_store)
        post :create, :store => {}
        response.should redirect_to(store_url(@new_store))
      end
      
    end
    
    describe "with invalid params" do

      before(:each) do
        @new_store.stub!(:save => false)
      end

      it "should expose a newly created but unsaved store as @store" do
        Store.stub!(:new).with({'these' => 'params'}).and_return(@new_store)
        post :create, :store => {:these => 'params'}
        assigns(:store).should equal(@new_store)
      end

      it "should re-render the 'new' template" do
        Store.stub!(:new).and_return(@new_store)
        post :create, :store => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT update" do

    before(:each) do
      Store.should_receive(:find).with(@store.id.to_s).and_return(@store)
    end

    it "should update the requested store" do
      @store.should_receive(:update_attributes).with({'these' => 'params'})
      put :update, :id => @store.id, :store => {:these => 'params'}
    end

    describe "with valid params" do

      before(:each) do
        @store.stub!(:update_attributes => true)
      end

      it "should expose the requested store as @store" do
        put :update, :id => @store.id
        assigns(:store).should equal(@store)
      end

      it "should redirect to the store" do
        put :update, :id => @store.id
        response.should redirect_to(store_url(@store))
      end

    end
    
    describe "with invalid params" do

      before(:each) do
        @store.stub!(:update_attributes => false)
      end

      it "should expose the store as @store" do
        put :update, :id => @store.id
        assigns(:store).should equal(@store)
      end

      it "should re-render the 'edit' template" do
        put :update, :id => @store.id
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested store" do
      Store.should_receive(:find).with(@store.id.to_s).and_return(@store)
      @store.should_receive(:destroy)
      delete :destroy, :id => @store.id
    end
  
    it "should redirect to the stores list" do
      delete :destroy, :id => @store.id
      response.should redirect_to(stores_url)
    end

  end

end
