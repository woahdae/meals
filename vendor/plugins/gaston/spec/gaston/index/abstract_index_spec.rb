require 'spec_helper'

module Gaston
  module Index
    describe AbstractIndex do
      describe "#rebuild" do
        class Record < Spec::FakeActiveRecord
          attr_accessor :id, :name, :value
        end

        before(:each) do
          @index = AbstractIndex.new("spec_house")
          @index.indexed_classes << Record
          @ferret_index = mock("ferret index").as_null_object
          @index.stub!(:ferret_index).and_return(@ferret_index)
        end

        it "adds a document for every row of every class" do
          mock1 = double("record", :id => 5).as_null_object
          mock2 = double("record", :id => 7).as_null_object
          Record.stub!(:find).and_return([mock1, mock2])

          @ferret_index.should_receive(:<<).exactly(2).times
          @index.rebuild
        end
      end
      context "updating the index" do
        class Record < Spec::FakeActiveRecord
          attr_accessor :id, :name, :value
        end

        before(:each) do
          @index = AbstractIndex.new("spec_house_cards")
          @index.indexed_classes << Record
          @ferret_index = mock("ferret index").as_null_object
          @index.stub!(:ferret_index).and_return(@ferret_index)
        end

        describe "#rebuild" do
          it "adds a document for every row of every class" do
            mock1 = mock("record", :id => 5).as_null_object
            mock2 = mock("record", :id => 7).as_null_object
            Record.stub!(:find).and_return([mock1, mock2])

            @ferret_index.should_receive(:<<).exactly(2).times
            @index.rebuild
          end

          it "adds a field for every field specified" do
            mock = mock("record", :id => 5, :class => Record).as_null_object
            Record.stub!(:find).and_return([mock])

            @index.fields "Gaston::Index::Record", [:name, :value]
            @ferret_index.should_receive(:<<).with(hash_including(:name => anything,
                                                                  :value => anything))
            @index.rebuild
          end

          it "gets the fields info from the database rows" do
            mock = mock("record", :name => "Spec Record", :id => 6, :class => Record).as_null_object
            Record.stub!(:find).and_return([mock])

            @index.fields "Gaston::Index::Record", [:name]
            @ferret_index.should_receive(:<<).with(hash_including(:name => "Spec Record"))
            @index.rebuild
          end
        end

        describe "#update" do
          it "adds the updated object to the ferret index" do
            record = mock("record", :id => 6).as_null_object
            @ferret_index.should_receive(:add_document).with(hash_including(:id => 6))
            @index.update(record)
          end
        end
      end
    end
  end
end
