require 'spec_helper'

describe UnitWithDensity do
  def build(unit, density = "100 grams".to_unit / "1 cup".to_unit)
    UnitWithDensity.new(unit, :density => density)
  end

  it "can be summed in an array" do
    ["2 cups", "1 gram", "2 tablespoons", "1 lb"]\
      .map {|elem| build(elem)}.sum.should eq_unit("1.47069 lbs")
  end

  describe "#+" do
    it "adds compatible units" do
      (build("30 grams") + build("1 lb")).unit.should eq_unit("1.0625 lbs")
    end

    it "adds a volume to a weight" do
      (build("1 cup") + build("100 grams")).unit.should eq_unit("200 grams")
    end

    it "adds a weight to a volume" do
      (build("100 grams") + build("1 cup")).unit.should eq_unit("2 cups")
    end

    it "adds compound units" do
      # note that this doesn't make sense unless part of an avg operation or something
      (build("1 USD/oz") + build("1 USD/lb")).unit.should eq_unit("17 USD/lb")
    end

    it "adds normal units" do
      (build("1 cup") + "100 grams").should eq_unit("200 grams")
    end
  end

  describe "#-" do
    it "subtracts compatible units" do
      (build("1 lb") - build("30 grams")).unit.should eq_unit("423.592 grams")
    end

    it "subtracts a volume from a weight" do
      (build("100 grams") - build("1/2 cup")).unit.should eq_unit("1/2 cup")
    end

    it "subtracts a weight from a volume" do
      (build("1 cup") - build("50 grams")).unit.should eq_unit("50 grams")
    end
  end

  describe "#abs" do
    it "returns the absolute value of the unit" do
      # I don't know why Unit#abs returns a unitless number,
      # but I don't care right now
      build("-1 cups").abs.should == build("1")
    end
  end

  describe "#<" do
    context "compares itself's unit to another's unit" do
      it "for compatible units" do
        build("1 gram").should < build("1 oz")
      end

      it "when comparing mass with a volume" do
        build("1 gram").should < build("1 cup")
      end

      it "when comparing volume with a mass" do
        build("1 cup").should < build("101 grams")
      end
    end
  end

  describe "#convert_to" do
    it "converts compatible units" do
      build('1 pint').convert_to('cups').should eq_unit("2 cups")
    end

    it "converts a weight into a volume" do
      build("100 grams").convert_to('cups').should eq_unit("1 cup")
    end

    it "converts a volume into a weight" do
      build("1 cup").convert_to('grams').should eq_unit("100 grams")
    end
  end

  describe "#==" do
    it "compares compatible units" do
      build("28.3495 grams").should be_close(build("1 oz"), 0.01)
    end

    it "compares a volume to a mass" do
      build("1 cup").should == build("100 grams")
    end

    it "compares a mass to a volume" do
      build("100 grams").should == build("1 cup")
    end
  end
end