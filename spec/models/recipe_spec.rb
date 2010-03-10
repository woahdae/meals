require 'spec_helper'

describe Recipe do
  context "validation" do
    before(:each) do
      @valid_attributes = {
        :name => "value for name",
        :prep_time => "1.5",
        :cook_time => "1.5",
        :servings => "1",
        :directions => "value for directions",
        :user_id => 1
      }
    end

    it "passes when given given valid attributes" do
      Recipe.new(@valid_attributes).should be_valid
    end
  end
  
  it "sums cost from its items" do
    @receipt_item1 = Factory.build(:receipt_item, :qty => "2 lbs", :price => "5.00", :item_uid_id => 5000)
    @receipt_item2 = Factory.build(:receipt_item, :qty => "1 lbs", :price => "10.00", :item_uid_id => 6000)
    
    @uid1 = ItemUID.new(:receipt_items => [@receipt_item1])
    @uid2 = ItemUID.new(:receipt_items => [@receipt_item2])
    
    @item1 = Factory.build(:item, :qty => "8 oz", :uid => @uid1)
    @item2 = Factory.build(:item, :qty => "16 oz", :uid => @uid2)
    
    recipe = Factory.build(:recipe, :items => [@item1, @item2])

    recipe.average_price.round(2).to_s.should == "11.25"
  end
  
  it "sums nutrition data from its items" do
    item1 = mock_model(Item, :measure => 100)
    item2 = mock_model(Item, :measure => 100)
    recipe = Recipe.new(:items => [item1, item2], :servings => 1)
    recipe.measure(:kcal).should == 200
  end
  
  context "" do
    before do
      @recipe = Recipe.new(
        :photos => [mock_model(RecipePhoto)],
        :items => [
          mock_model(Item, 
            :item_uid_id => 5000, 
            :uid => mock('UID', 
              :receipt_items => [
                  mock('receipt') ]))])
    end
    
    describe "missing" do
    
      it "is blank if nothing is missing" do
        @recipe.missing.should be_blank
      end
    
      it "has 'photos' => true if photos are missing" do
        @recipe.photos.target = []
        @recipe.missing.should == {'photos' => true}
      end

      it "has 'uid' => [item] if an item has no UID" do
        @recipe.items.first.stub!(:item_uid_id, nil)
        @recipe.missing.should == {'uid' => [@recipe.items.first]}
      end

      it "has 'receipts' => [item] if an item has no receipts" do
        @recipe.items.first.uid.stub!(:receipt_items, [])
        @recipe.missing.should == {'receipts' => [@recipe.items.first]}
      end
    end
    
    describe "completion" do
      it "is 100% when nothing is missing" do
        @recipe.completion.should == 1
      end
      
      it "is 67% when 1 item and photos are missing" do
        @recipe.photos.target = []
        @recipe.completion.round(2).should == 0.67
      end

      it "is 67% when 1 item and has no UID" do
        @recipe.items.first.stub!(:item_uid_id, nil)
        @recipe.completion.round(2).should == 0.67
      end

      it "is 67% when 1 item and has no receipts" do
        @recipe.items.first.uid.stub!(:receipt_items, [])
        @recipe.completion.round(2).should == 0.67
      end
    end
  end
  
  describe "serving_size" do
    it "sums item qty when items have compatible units" do
      recipe = Recipe.new(
        :servings => 2,
        :items => [
          item1 = mock_model(Item, :qty => "1 lb".to_unit),
          item2 = mock_model(Item, :qty => "6 oz".to_unit)])

      recipe.serving_size.convert_to("oz").to_s.should == "11 oz"
    end
    
    it "returns nil with incompatable units" do
      recipe = Recipe.new(
        :servings => 2,
        :items => [
          item1 = mock_model(Item, :qty => "1 lb".to_unit),
          item2 = mock_model(Item, :qty => "6 cups".to_unit)])

      recipe.serving_size.should be_nil
    end
  end
end
