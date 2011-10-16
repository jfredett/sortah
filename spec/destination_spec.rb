require 'spec_helper'

describe Sortah::Destination do

  context "when creating a destination" do
    it "should be able to show me it's destination path" do
      dest = Sortah::Destination.new(:foo, "bar")  
      dest.path.should == "bar"
    end
  end

  context "when comparing a destination with another object, " do
    it "should be equal to itself" do
      dest = Sortah::Destination.new(:foo, "bar")  
      (dest == dest).should be_true
    end

    it "should not be equal to a destination which has a different path" do
      dest = Sortah::Destination.new(:foo, "bar")  
      dest2 = Sortah::Destination.new(:bar, "baz")
      (dest == dest2).should_not be_true
    end

    it "should not be equal to a destination which has the same path, but different name" do
      dest = Sortah::Destination.new(:foo, "baz")  
      dest2 = Sortah::Destination.new(:bar, "baz")
      (dest == dest2).should_not be_true
    end

    it "should be equal to an equivalent destination" do
      dest = Sortah::Destination.new(:foo, "baz")
      dest2 = Sortah::Destination.new(:foo, "baz")
      (dest == dest2).should be_true
    end

    it "should be equal to a string which is identical to the absolute path it describes" do
      dest = Sortah::Destination.new(:foo, "baz")
      (dest == "baz").should be_true
    end
  end

end
