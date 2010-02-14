require 'spec_helper'

describe ChainsController do

  before(:each) do
    @chain = Factory(:chain)
  end

  describe "responding to GET index" do

    it "should expose all chains as @chains" do
      get :index
      assigns[:chains].should == [@chain]
    end

    describe "with mime type of xml" do
  
      it "should render all chains as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Chain.should_receive(:find).with(:all).and_return(chains = mock("Array of Chains"))
        chains.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested chain as @chain" do
      get :show, :id => @chain.id
      assigns[:chain].should == @chain
    end
    
    describe "with mime type of xml" do

      it "should render the requested chain as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Chain.should_receive(:find).with("37").and_return(@chain)
        @chain.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new chain as @chain" do
      chain = Factory.build(:chain)
      Chain.should_receive(:new).and_return(chain)
      get :new
      assigns[:chain].should equal(chain)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested chain as @chain" do
      get :edit, :id => @chain.id
      assigns[:chain].should == @chain
    end

  end

  describe "responding to POST create" do

    before(:each) do
      @new_chain = Factory.build(:chain, :name => 'Something Unique')
    end

    describe "with valid params" do

      it "should expose a newly created chain as @chain" do
        Chain.should_receive(:new).with({'these' => 'params'}).and_return(@new_chain)
        post :create, :chain => {:these => 'params'}
        assigns(:chain).should equal(@new_chain)
      end

      it "should redirect to the created chain" do
        Chain.stub!(:new).and_return(@new_chain)
        post :create, :chain => {}
        response.should redirect_to(chain_url(@new_chain))
      end
      
    end
    
    describe "with invalid params" do

      before(:each) do
        @new_chain.stub!(:save => false)
      end

      it "should expose a newly created but unsaved chain as @chain" do
        Chain.stub!(:new).with({'these' => 'params'}).and_return(@new_chain)
        post :create, :chain => {:these => 'params'}
        assigns(:chain).should equal(@new_chain)
      end

      it "should re-render the 'new' template" do
        Chain.stub!(:new).and_return(@new_chain)
        post :create, :chain => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT update" do

    before(:each) do
      Chain.should_receive(:find).with(@chain.id.to_s).and_return(@chain)
    end

    it "should update the requested chain" do
      @chain.should_receive(:update_attributes).with({'these' => 'params'})
      put :update, :id => @chain.id, :chain => {:these => 'params'}
    end

    describe "with valid params" do

      before(:each) do
        @chain.stub!(:update_attributes => true)
      end

      it "should expose the requested chain as @chain" do
        put :update, :id => @chain.id
        assigns(:chain).should equal(@chain)
      end

      it "should redirect to the chain" do
        put :update, :id => @chain.id
        response.should redirect_to(chain_url(@chain))
      end

    end
    
    describe "with invalid params" do

      before(:each) do
        @chain.stub!(:update_attributes => false)
      end

      it "should expose the chain as @chain" do
        put :update, :id => @chain.id
        assigns(:chain).should equal(@chain)
      end

      it "should re-render the 'edit' template" do
        put :update, :id => @chain.id
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested chain" do
      Chain.should_receive(:find).with(@chain.id.to_s).and_return(@chain)
      @chain.should_receive(:destroy)
      delete :destroy, :id => @chain.id
    end
  
    it "should redirect to the chains list" do
      delete :destroy, :id => @chain.id
      response.should redirect_to(chains_url)
    end

  end

end
