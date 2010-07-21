require 'spec_helper'

describe List do
  it "is valid given valid attributes" do
    List.new({}).should be_valid
  end

  describe "#measure" do
    it "measures a nutrient across all recipes" do
      subject.list_items = [
        mock_model(ListItem, :name => "Blah", :qty => "1 g", :measure => 300),
        mock_model(ListItem, :name => "Woo",  :qty => "1 g", :measure => 500)]
      subject.measure('blah').should == 800
      subject.measure("blah").missing.should be_empty
    end

    it "returns a measurement with missing for items that can't be measured" do
      subject.list_items = [
        mock_model(ListItem, :name => "Blah", :qty => "1 g", :measure => 300),
        mock_model(ListItem, :name => "Woo",  :qty => "1 g", :measure => nil)]
      subject.measure('blah').missing.should_not be_empty
    end
  end

  it "calculates servings" do
    list = List.new
    list.stub_chain(:recipes, :summary).and_return([
       recipe1 = mock_model(Recipe, :name => "Boo", :servings => 2),
       recipe2 = mock_model(Recipe, :name => "Baa", :servings => 4) ])
  
    list.servings.value.should == 6
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
        :name  => "Blah Woo",
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
