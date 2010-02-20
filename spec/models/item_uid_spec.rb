require 'spec_helper'

describe ItemUID do
  describe "validation:" do
    before(:each) do
      @valid_attributes = {
      }
    end

    it "creates a new instance given valid attributes" do
      ItemUID.new(@valid_attributes).should be_valid
    end
  end
  
  it "belongs to usda_abbreviated_data" do
    ItemUID.new(:usda_ndb_id => 1001).usda_abbreviated_data.should be_present
  end

  it "belongs to usda_food_description" do
    ItemUID.new(:usda_ndb_id => 1001).usda_food_description.should be_present
  end
  
  describe "fallback_search_by_name" do
    it "searches the USDA Nutrition Database" do
      ItemUID.stub!(:all)
      
      UsdaNdb::AbbreviatedData.should_receive(:all) do |options|
        options[:conditions].should == "short_description LIKE '%Tofu%'"
        []
      end
      
      ItemUID.fallback_search_by_name("Tofu")
    end
    
    it "uses the NDB search to find the corresponding ItemUIDs" do
      UsdaNdb::AbbreviatedData.stub!(:all).and_return([mock("ndb data", :ndb_no => 10000)])
      
      ItemUID.should_receive(:all).with(:conditions => {:usda_ndb_id => [10000]})
      
      ItemUID.fallback_search_by_name("Blah")
    end
    
    it "doesn't search for blank values" do
      UsdaNdb::AbbreviatedData.should_not_receive(:all)
      
      ItemUID.fallback_search_by_name("")
    end
  end
  
end
