require 'spec_helper'

describe ItemUID do
  
  describe "validation" do
    before(:each) do
      @valid_attributes = {
      }
    end

    it "passes when given valid attributes" do
      ItemUID.new(@valid_attributes).should be_valid
    end
  end
  
  it "belongs to usda_abbreviated_data" do
    ItemUID.new(:usda_ndb_id => 1001).usda_abbreviated_data.should be_present
  end

  it "belongs to usda_food_description" do
    ItemUID.new(:usda_ndb_id => 1001).usda_food_description.should be_present
  end

  describe "volume_to_weight" do
    it "returns the food quantity if it's a weight" do
      uid = ItemUID.new(:food => Factory.build(:food, :servings => "2", :serving_size => "1 lb"))
      uid.volume_to_weight(uid.food.qty).should == "2 lbs"
    end
    
    it "attempts to turn volume to a weight for usda items" do
      usda = mock_model(UsdaNdb::AbbreviatedData)
      uid = ItemUID.new(:usda_abbreviated_data => usda)
      usda.should_receive(:volume_to_weight).with("2 oz")
      uid.volume_to_weight("2 oz")
    end
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
