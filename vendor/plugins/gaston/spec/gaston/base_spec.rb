require "spec_helper"

module Gaston
  class Doc
    extend Base
    attr_accessor :name, :type
  end

  describe Base do
    before(:each) do
      @index = double("Index").as_null_object
      @index.stub!(:fields)
      Gaston::Index.stub!(:instance).and_return(@index)
    end

    describe "#define_index" do
      it "passes the correct index into the block" do
        Doc.define_index do |index|
          index.should == @index
        end
      end

      it "registers the fields with the index" do
        @index.should_receive(:fields).with(anything, array_including([:name, :type]))
        Doc.define_index do |index|
          index.fields :name, :type
        end
      end
    end

    describe "#search" do
      it "passes the query to the index" do
        @index.should_receive(:search).with(Doc.name, match(/query string/), {})
        Doc.search("query string")
      end

      it "adds the ferret_class to the query" do
        @index.should_receive(:search).with(Doc.name, match(/^\+ferret_class:#{Doc.name}/), {})
        Doc.search("query string")
      end
    end
  end
end
