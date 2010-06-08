require 'spec_helper'

describe FerretFood do
  before do
    @item = mock_model(Food, 
      :name => "Eggs, Green",
      :first_word_in_name => "Eggs",
      :id => 1)
    Food.stub!(:find).and_return([@item], [])
    FerretFood.rebuild
  end
  
  after do
    # clears the index
    FerretFood.ferret_index(:create => true) {|f_idx| }
  end
  
  def index_size_should_be(int)
    FerretFood.ferret_index {|f_idx| f_idx.size.should == int}
  end
  
  def search_index(term)
    results = []
    FerretFood.ferret_index {|f_idx| f_idx.search_each(term) {|id, _| results << f_idx[id]}}
    results
  end
  
  it "rebuilds the index" do
    index_size_should_be(1)
  end
  
  it "deletes items on the index" do
    FerretFood.delete(@item)
    index_size_should_be(0)
  end
  
  it "updates items on the index" do
    @item.stub!(:name).and_return("Eggs, Blue")
    FerretFood.update(@item)
    search_index("Eggs").first[:name].should == "Eggs, Blue"
  end
  
  it "updates new items on the index" do
    @item.stub!(:name).and_return("Eggs, Blue")
    @item.stub!(:id).and_return(nil)
    FerretFood.update(@item)
    search_index("Blue Eggs").first[:name].should == "Eggs, Blue"
  end
  
  it "searches by name" do
    FerretFood.search_by_name("Green Eggs").first.name.should == "Eggs, Green"
  end
end

describe FerretFood do
  context "search" do
    after do
      # clears the index
      FerretFood.ferret_index(:create => true) {|f_idx| }
    end
    
    it "ignores pluralization" do
      item1 = mock_model(Food, 
        :name => "Peppers, jalapeno, raw",
        :first_word_in_name => "Pepper",
        :id => 1)
      item2 = mock_model(Food, 
          :name => "Pepper, serrano, raw",
          :first_word_in_name => "Pepper",
          :id => 2)
      
      Food.stub!(:find).and_return([item1, item2], [])
      FerretFood.rebuild
      
      FerretFood.search_by_name("serrano peppers").first.name.should == "Pepper, serrano, raw"
    end
  end
end
