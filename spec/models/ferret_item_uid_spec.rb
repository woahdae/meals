require 'spec_helper'

describe FerretItemUID do
  before do
    @item = mock_model(ItemUID, 
      :name => "Eggs, Green",
      :first_word_in_name => "Eggs",
      :id => 1)
    ItemUID.stub!(:find).and_return([@item], [])
    FerretItemUID.rebuild
  end
  
  after do
    # clears the index
    FerretItemUID.ferret_index(:create => true) {|f_idx| }
  end
  
  def index_size_should_be(int)
    FerretItemUID.ferret_index {|f_idx| f_idx.size.should == int}
  end
  
  def search_index(term)
    results = []
    FerretItemUID.ferret_index {|f_idx| f_idx.search_each(term) {|id, _| results << f_idx[id]}}
    results
  end
  
  it "rebuilds the index" do
    index_size_should_be(1)
  end
  
  it "deletes items on the index" do
    FerretItemUID.delete(@item)
    index_size_should_be(0)
  end
  
  it "updates items on the index" do
    @item.stub!(:name).and_return("Eggs, Blue")
    FerretItemUID.update(@item)
    search_index("Eggs").first[:name].should == "Eggs, Blue"
  end
  
  it "updates new items on the index" do
    @item.stub!(:name).and_return("Eggs, Blue")
    @item.stub!(:id).and_return(nil)
    FerretItemUID.update(@item)
    search_index("Blue Eggs").first[:name].should == "Eggs, Blue"
  end
  
  it "searches by name" do
    FerretItemUID.search_by_name("Green Eggs").first.name.should == "Eggs, Green"
  end
end

describe FerretItemUID do
  context "search" do
    after do
      # clears the index
      FerretItemUID.ferret_index(:create => true) {|f_idx| }
    end
    
    it "ignores pluralization" do
      item1 = mock_model(ItemUID, 
        :name => "Peppers, jalapeno, raw",
        :first_word_in_name => "Pepper",
        :id => 1)
      item2 = mock_model(ItemUID, 
          :name => "Pepper, serrano, raw",
          :first_word_in_name => "Pepper",
          :id => 2)
      
      ItemUID.stub!(:find).and_return([item1, item2], [])
      FerretItemUID.rebuild
      
      FerretItemUID.search_by_name("serrano peppers").first.name.should == "Pepper, serrano, raw"
    end
  end
end








