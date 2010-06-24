require 'spec_helper'

describe List do
  it "is valid given valid attributes" do
    List.new({}).should be_valid
  end

  describe "#measure" do
    it "measures a nutrient across all recipes" do
      subject.list_items = [
        mock_model(ListItem, :measure => 300),
        mock_model(ListItem, :measure => 500)]
      subject.measure('blah').should == 800
    end

    it "returns nil if all nutrients can't be measured" do
      subject.list_items = [
        mock_model(ListItem, :measure => 300),
        mock_model(ListItem, :measure => nil)]
      subject.measure('blah').should be_nil
    end
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

  describe "#add_recipe" do
    let(:item1) {
      mock('Item',
        :name             => "blah",
        :food_id          => 5,
        :qty              => "1 lb",
        :qty_with_density => "1 lb".to_unit)}
    let(:recipe) {
      mock('Recipe',
        :id    => 1,
        :items => [item1])}

    it "adds all of a recipes items to a list" do
      subject.list_items.should_receive(:create)\
        .with(:food_id => 5, :recipe_id => 1, :qty => "1 lb", :name => "blah")
      subject.add_recipe(recipe)
    end

    it "adds more qty to existing items" do
      existing = mock_model(ListItem, :food_id => 5, :qty => "1 lb".to_unit)
      subject.list_items = [existing]
      existing.should_receive(:update_attributes).with({:qty => "2 lbs"})
      subject.add_recipe(recipe)
    end
  end
end
