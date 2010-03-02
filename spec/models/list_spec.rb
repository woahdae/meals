require 'spec_helper'

describe List do
  it "is valid given valid attributes" do
    List.new({}).should be_valid
  end

  describe "combined_items" do
    before do
      @list = List.new
      recipe1 = mock_model(Recipe, :items => [
        Item.new(:item_uid_id => 500, :qty => "5 oz"),
        Item.new(:item_uid_id => 600, :qty => "8 oz") ])
      recipe2 = mock_model(Recipe, :items => [
        Item.new(:item_uid_id => 500, :qty => "1 lb"),
        Item.new(:item_uid_id => 700, :qty => "2 cups") ])
      recipe3 = mock_model(Recipe, :items => [
        Item.new(:item_uid_id => 700, :qty => "5 tbsp"),
        Item.new(:item_uid_id => 800, :qty => "10 oz") ])
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
