require 'spec_helper'

describe List do
  it "is valid given valid attributes" do
    List.new({}).should be_valid
  end
  
  it "calculates servings" do
    list = List.new(:recipes => [
       recipe1 = mock_model(Recipe, :servings => 2),
       recipe2 = mock_model(Recipe, :servings => 4)])
  
    list.servings.should == 6
    
  end
  
  describe "serving_size" do
    it "sums recipe serving size when compatable units" do
      list = List.new(:recipes => [
         recipe1 = mock_model(Recipe, :serving_size => "1 lb".to_unit),
         recipe2 = mock_model(Recipe, :serving_size => "5 oz".to_unit)])
    
      list.serving_size.convert_to("oz").to_s.should == "21 oz"
    end
    
    it "returns nil with incompatable units" do
      list = List.new(:recipes => [
         recipe1 = mock_model(Recipe, :serving_size => "1 lb".to_unit),
         recipe2 = mock_model(Recipe, :serving_size => "5 cups".to_unit)])
    
      list.serving_size.should == nil
    end
  end
  
  describe "combined_items" do
    before do
      @list = List.new
      @uid1 = ItemUID.new(:id => 1, :usda_ndb_id => 1123)
      @uid2 = ItemUID.new(:id => 2, :usda_ndb_id => 1124)
      @uid3 = ItemUID.new(:id => 3, :usda_ndb_id => 1125)
      @uid4 = ItemUID.new(:id => 4, :usda_ndb_id => 1126)
      recipe1 = mock_model(Recipe, :items => [
        Item.new(:uid => @uid1, :qty => "5 oz"),
        Item.new(:uid => @uid2, :qty => "8 oz") ])
      recipe2 = mock_model(Recipe, :items => [
        Item.new(:uid => @uid1,  :qty => "1 lb"),
        Item.new(:uid => @uid3, :qty => "2 cups") ])
      recipe3 = mock_model(Recipe, :items => [
        Item.new(:uid => @uid3, :qty => "5 tbsp"),
        Item.new(:uid => @uid4, :qty => "10 oz") ])
      @list.recipes = [recipe1, recipe2, recipe3]
    end
    
    it "combines items" do
      @list.combined_items.size.should == 4
    end
    
    it "combines items' quantities" do
      @list.combined_items.find {|item| item.item_uid_id == 500}.qty.to_s.should == "21 oz"
    end
    
    it "returns the same results every time (i.e. non-destructive)" do
      @list.combined_items
      @list.combined_items
      @list.combined_items.find {|item| item.item_uid_id == 500}.qty.to_s.should == "21 oz"
    end
  end
end
