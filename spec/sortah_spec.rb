require 'spec_helper'

describe Sortah::Parser do
  context "when parsing language components, " do

    before :each do
      sortah.clear
    end

    context "when parsing destinations, " do
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

      it "should throw a parse error when you try to redefine a destination" do
        expect {
          sortah do
            destination :same_dest, "dest/"
            destination :same_dest, "dest/"
          end
        }.should raise_error Sortah::ParseErrorException
      end

    end

    context "when parsing lenses," do

      it "should parse a lens definition" do
        sortah do
          lens :test_value do
            1
          end
        end
      end

      it "should parse a lens definition that depends on another lens" do
        sortah do
          lens :dep do
            1
          end

          lens :test_value, lenses: [:dep] do
            2
          end
        end
      end

      it "should throw a parse error if you try to define the same lens (by name) twice" do
        expect {
          sortah do
            lens :same_name do
            end
            lens :same_name do
            end
          end
        }.should raise_error Sortah::ParseErrorException
      end

    end

    end

    context "when dealing in general with sortah, " do

      it "should have access to an email object" do
        sortah do
          email
        end
      end

      it "should allow for configuration" do
        sortah do
          maildir "/home/user/.mail" #mail directory, maildir format
        end
        sortah.result.maildir.should == "/home/user/.mail"
      end

      it "should use the last defined maildir" do
        sortah do
          maildir "/home/user/.mail/work"
          maildir "/home/user/.mail/personal"
        end
        sortah.result.maildir.should == "/home/user/.mail/personal"
      end

    end

  end
end
