require 'spec_helper'

describe ItemUidsController do
  before(:each) do
    log_in
    @item_uid = mock("FerretItemUID", :id => "123", :name => "Noodles")
  end
  
  describe "responding to GET search" do

    describe "with mime type of json" do

      it "should render the requested recipe as json" do
        request.env["HTTP_ACCEPT"] = "application/json"
        FerretItemUID.should_receive(:search_by_name).with("Noodles").and_return([@item_uid])
        @item_uid.should_receive(:to_json).and_return("generated JSON")
        get :search, :name => "Noodles"
        response.body.should == "[generated JSON]"
      end

    end
  end
end