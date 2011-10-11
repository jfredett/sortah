require 'spec_helper'

describe Sortah::Parser do
  context "when parsing language components" do
    it "should provide an environment for definiton" do
      result = sortah do
      end
      result.should_not be_nil
    end
  end
end
