require 'spec_helper'

describe ReceiptsController do

  before(:each) do
    log_in
    @receipt = Factory(:receipt, :user => @current_user)
  end

  describe "responding to GET index" do

    it "should expose all receipts as @receipts" do
      get :index
      assigns[:receipts].should == [@receipt]
    end

    describe "with mime type of xml" do
  
      it "should render all receipts as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Receipt.should_receive(:all).and_return(receipts = mock("Array of Receipts"))
        receipts.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested receipt as @receipt" do
      get :show, :id => @receipt.id
      assigns[:receipt].should == @receipt
    end
    
    describe "with mime type of xml" do

      it "should render the requested receipt as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Receipt.should_receive(:find).with("37").and_return(@receipt)
        @receipt.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new receipt as @receipt" do
      receipt = Factory.build(:receipt)
      Receipt.should_receive(:new).and_return(receipt)
      get :new
      assigns[:receipt].should equal(receipt)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested receipt as @receipt" do
      get :edit, :id => @receipt.id
      assigns[:receipt].should == @receipt
    end

  end

  describe "responding to POST create" do

    before(:each) do
      @new_receipt = Factory.build(:receipt)
    end

    describe "with valid params" do

      it "should expose a newly created receipt as @receipt" do
        Receipt.should_receive(:new).with({'these' => 'params'}).and_return(@new_receipt)
        post :create, :receipt => {:these => 'params'}
        assigns(:receipt).should equal(@new_receipt)
      end

      it "should redirect to the created receipt" do
        Receipt.stub!(:new).and_return(@new_receipt)
        post :create, :receipt => {}
        response.should redirect_to(receipt_url(@new_receipt))
      end
      
    end
    
    describe "with invalid params" do

      before(:each) do
        @new_receipt.stub!(:save => false)
      end

      it "should expose a newly created but unsaved receipt as @receipt" do
        Receipt.stub!(:new).with({'these' => 'params'}).and_return(@new_receipt)
        post :create, :receipt => {:these => 'params'}
        assigns(:receipt).should equal(@new_receipt)
      end

      it "should re-render the 'new' template" do
        Receipt.stub!(:new).and_return(@new_receipt)
        post :create, :receipt => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT update" do

    before(:each) do
      Receipt.should_receive(:find).with(@receipt.id.to_s).and_return(@receipt)
    end

    it "should update the requested receipt" do
      @receipt.should_receive(:update_attributes).with({'these' => 'params'})
      put :update, :id => @receipt.id, :receipt => {:these => 'params'}
    end

    describe "with valid params" do

      before(:each) do
        @receipt.stub!(:update_attributes => true)
      end

      it "should expose the requested receipt as @receipt" do
        put :update, :id => @receipt.id
        assigns(:receipt).should equal(@receipt)
      end

      it "should redirect to the receipt" do
        put :update, :id => @receipt.id
        response.should redirect_to(receipt_url(@receipt))
      end

    end
    
    describe "with invalid params" do

      before(:each) do
        @receipt.stub!(:update_attributes => false)
      end

      it "should expose the receipt as @receipt" do
        put :update, :id => @receipt.id
        assigns(:receipt).should equal(@receipt)
      end

      it "should re-render the 'edit' template" do
        put :update, :id => @receipt.id
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested receipt" do
      Receipt.should_receive(:find).with(@receipt.id.to_s).and_return(@receipt)
      @receipt.should_receive(:destroy)
      delete :destroy, :id => @receipt.id
    end
  
    it "should redirect to the receipts list" do
      delete :destroy, :id => @receipt.id
      response.should redirect_to(receipts_url)
    end

  end

end
