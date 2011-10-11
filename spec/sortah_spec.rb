require 'spec_helper'

describe Sortah::Parser do
  context "when parsing language components" do
    it "should provide an environment for definiton" do
      result = sortah do
      end
      result.should_not be_nil
    end

    it "should store defined 'simple' destinations"  do
      result = sortah do
        destination :place, "somewhere/"
      end
      result.destinations[:place].should == "somewhere/"
    end

    it "should store defined 'absolute path' destinations" do
      result = sortah do
        destination :place, :abs => "/home/user/.mail/.somewhere.else/"
      end
      result.destinations[:place].should == "/home/user/.mail/.somewhere.else/"
    end

    it "should store defined 'alias' destinations in a dereferenced way" do
      result = sortah do
        destination :place, "somewhere/"
        destination :other_place, :place
      end
      result.destinations[:other_place].should == "somewhere/"
    end

  end
end
