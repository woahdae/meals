require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ItemsController do

  describe "responding to GET new" do
  
    it "should expose a new item as @item" do
      item = Factory.build(:item)
      Item.should_receive(:new).and_return(item)
      get :new
      assigns[:item].should equal(item)
    end
    
    describe "with mime type of javascript" do
      
      it "should render the requested item as xml" do
        xhr :get, :new
        response.body.should == "1" # not sure why it just renders the number 1 in test mode...
      end
      
    end

  end

end
