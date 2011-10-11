require 'spec_helper'

describe Sortah::Parser do
  context "when parsing language components" do
    before :each do
      sortah.clear
    end

    it "should provide an environment for definiton" do
      sortah do
      end
      sortah.result.should_not be_nil
    end

    it "should store defined 'simple' destinations"  do
      sortah do
        destination :place, "somewhere/"
      end
      sortah.result.destinations[:place].should == "somewhere/"
    end

    it "should store defined 'absolute path' destinations" do
      sortah do
        destination :place, :abs => "/home/user/.mail/.somewhere.else/"
      end
      sortah.result.destinations[:place].should == "/home/user/.mail/.somewhere.else/"
    end

    it "should store defined 'alias' destinations in a dereferenced way" do
      sortah do
        destination :place, "somewhere/"
        destination :other_place, :place
      end
      sortah.result.destinations[:other_place].should == "somewhere/"
    end

    it "should maintain one state across multiple sortah blocks" do
      sortah do
        destination :place, "somewhere/"
      end

      sortah do
        destination :new_place, :place
      end
      sortah.result.destinations[:place].should == "somewhere/"
      sortah.result.destinations[:new_place].should == "somewhere/"
    end
    end

  end
end
