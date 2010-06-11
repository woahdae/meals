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
      @food1 = Food.new
      @food2 = Food.new
      @food3 = Food.new
      @food4 = Food.new
      @food1.stub!(:id).and_return(1)
      @food2.stub!(:id).and_return(2)
      @food3.stub!(:id).and_return(3)
      @food4.stub!(:id).and_return(4)
      recipe1 = mock_model(Recipe, :items => [
        Item.new(:name => "Noodles",         :food => @food1, :qty => "5 oz"),
        Item.new(:name => "Sauce",           :food => @food2, :qty => "8 oz") ])
      recipe2 = mock_model(Recipe, :items => [
        Item.new(:name => "Organic Noodles", :food => @food1,  :qty => "1 lb"),
        Item.new(:name => "Meatballs",       :food => @food3, :qty => "2 cups") ])
      recipe3 = mock_model(Recipe, :items => [
        Item.new(:name => "Rice",            :food => @food3, :qty => "5 tbsp"),
        Item.new(:name => "Tofu",            :food => @food4, :qty => "10 oz") ])
      @list.recipes = [recipe1, recipe2, recipe3]
    end
    
    it "combines items"
    
    it "combines items' quantities"
    
    it "returns the same results every time (i.e. non-destructive)"
  end
end
