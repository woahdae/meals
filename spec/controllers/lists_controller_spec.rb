require 'spec_helper'

describe ListsController do

  before(:each) do
    @list = Factory(:list)
    session[:list_id] = @list.id
  end

  describe "responding to GET show" do

    it "should expose the requested list as @list" do
      get :show
      assigns[:list].should == @list
    end
    
    describe "with mime type of xml" do

      it "should render the requested list as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        controller.stub!(:find_list)
        
        List.should_receive(:find) do |id, opts|
          id.should == @list.id
          @list
        end
        @list.should_receive(:to_xml).and_return("generated XML")
        get :show
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested list" do
      List.should_receive(:find).with(@list.id).and_return(@list)
      @list.should_receive(:destroy)
      delete :destroy
    end
  
    it "should redirect to the homepage (or back)" do
      delete :destroy, :id => @list.id
      response.should redirect_to("/")
    end

  end

end
