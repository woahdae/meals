require File.join(File.dirname(__FILE__), "..","spec_helper")

module Gaston
  Index.index_type = Index::MemoryIndex

  describe Index do
    it "prevents instantiation" do
      lambda { Index.new }.should raise_error
    end

    context "delegates to the correct index" do
      before(:each) do
        @index = double("Index")
        Index.stub!(:instance).and_return(@index)
      end
      
      it "delegates rebuild to the correct index" do
        @index.should_receive(:rebuild)
        Index.rebuild
      end

      it "delegates update to the correct index" do
        o = Object.new
        @index.should_receive(:update).with(o)
        Index.update(o)
      end

      it "delegates search to the correct index" do
        @index.should_receive(:search).with("class", "q", {})
        Index.search("class", "q")
      end
    end

    describe "#instance" do
      it "returns an existing index for the client if there is one" do
        index = double("Spec index")
        Index.store["test_client"] = index
        Index.instance("test_client").should == index
      end
      
      it "creates an index for the client if there isn't one" do
        index = double("Spec index")
        Index.index_type.stub!(:new).and_return(index)
        Index.instance("another_client").should == index
      end

      it "puts created indexes in the store" do
        index = double("Spec index")
        Index.index_type.stub!(:new).and_return(index)
        Index.instance("test_client")
        Index.store["test_client"].should == index
      end

      it "creates an index of the correct type" do
        Index.index_type = Hash
        Index.instance("test_client")
        Index.store["test_client"].should be_instance_of(Hash)
      end

      after(:each) do
        Index.store.clear
      end
    end
  end
end
