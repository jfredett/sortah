require 'spec_helper'

describe Sortah::Parser do
  context "when parsing language components, " do
    before :each do
      Sortah::Parser.clear!
    end
    
    context "when parsing destinations, " do
      it "should provide an environment for definiton" do
        expect {
          sortah do
          end 
        }.should_not raise_error
        sortah.should_not be_nil
      end

      it "should parse defined 'simple' destinations"  do
        expect {
          sortah do
            destination :place, "somewhere/"
          end
        }.should_not raise_error
        sortah.destinations[:place].should == "somewhere/"
      end

      it "should parse defined 'absolute path' destinations" do
        expect {
          sortah do
            destination :place, :abs => "/home/user/.mail/.somewhere.else/"
          end
        }.should_not raise_error
        sortah.destinations[:place].should == "/home/user/.mail/.somewhere.else/"
      end

      it "should parse defined 'alias' destinations in a dereferenced way" do
        expect {
          sortah do
            destination :place, "somewhere/"
            destination :other_place, :place
          end
        }.should_not raise_error
        sortah.destinations[:other_place].should == "somewhere/"
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
        expect {
          sortah do
            lens :test_value do
              1 
            end
          end
        }.should_not raise_error
      end

      it "should parse a lens definition that depends on another lens" do
        expect {
          sortah do
            lens :dep do
              1
            end

            lens :test_value, lenses: [:dep] do
              2
            end
          end
        }.should_not raise_error
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
      
      it "should throw a parse error if you try to reference a lens which does not exist" do
        expect {
          sortah do
            lens :other_name, :lenses => [:non_existant] do
            end
          end
        }.should raise_error Sortah::ParseErrorException

      end

      it "should not throw a parse error if you try to forward-reference a lens" do
        expect {
          sortah do
            lens :forward_reference, :lenses => [:ahead] do
            end
            lens :ahead do
            end
          end
        }.should_not raise_error Sortah::ParseErrorException
      end

      it "should not throw a parse error if you have a cyclic-lens dependency" do
        expect {
          sortah do
            lens :circle_one, :lenses => [:circle_two] do
            end
            lens :circle_two, :lenses => [:circle_one] do
            end
          end
        }.should_not raise_error Sortah::ParseErrorException
      end

    end

    context "when parsing routers, " do

      it "should parse a router definition" do
        expect {
          sortah do
            router :test_router do
            end
          end
        }.should_not raise_error

      end

      it "should parse a root-router definition" do
        expect {
          sortah do
            router do
            end
          end
        }.should_not raise_error
      end

      it "should parse a router with lenses" do
        expect {
          sortah do
            lens :foo do
            end

            router :test_router, :lenses => [:foo] do
            end
          end
        }.should_not raise_error
      end

      it "should parse a root-router with lenses" do
        expect {
          sortah do
            lens :foo do
            end
            
            router :lenses => [:foo] do
            end
          end
        }.should_not raise_error
      end

      it "should parse a router with a forward reference to a lens" do
        expect {
          sortah do
            router :foo_router, :lenses => [:foo] do
            end

            lens :foo do
            end
          end
        }.should_not raise_error
      end
      
      it "should parse a root-router with a forward reference to a lens" do
        expect {
          sortah do
            router :lenses => [:foo] do
            end

            lens :foo do
            end
          end
        }.should_not raise_error
      end

    end

    context "when dealing in general with sortah, " do
      it "should parse an 'error_dest' clause" do
        expect {
          sortah do
            error_dest 'errors/'
          end
        }.should_not raise_error
      end

      it "error_dest should provide access via a #error_dest method" do
        sortah do
          error_dest 'errors/'
        end
        sortah.error_dest.should == "errors/"
      end

      it "should maintain one state across multiple sortah blocks" do
        expect {
          sortah do
            destination :place, "somewhere/"
          end
        }.should_not raise_error

        expect {
          sortah do
            destination :new_place, :place
          end
        }.should_not raise_error

        sortah.destinations[:place].should == "somewhere/"
        sortah.destinations[:new_place].should == "somewhere/"
      end

      it "should allow for configuration" do
        sortah do
          maildir "/home/user/.mail" #mail directory, maildir format
        end
        sortah.maildir.should == "/home/user/.mail"
      end

      it "should use the last defined maildir" do
        sortah do
          maildir "/home/user/.mail/work"
          maildir "/home/user/.mail/personal"
        end
        sortah.maildir.should == "/home/user/.mail/personal"
      end

      it "should pass over a nested #sortah block" do
        expect { 
          sortah do
            sortah do
              destination :foo, "foo/"

              sortah do
              end
            end
          end 
        }.should_not raise_error
        sortah.destinations[:foo].should == 'foo/'
      end
    end

    #acceptance criteria
    it "should parse an example sortah file, which contains all of the language elements" do
      expect { 
        sortah do
          sortah do
            destination :place, "somewhere"
            destination :devnull, :abs => "/dev/null"
            destination :bitbucket, :devnull
          end

          lens :random_value do
            rand
          end

          lens :random_spam_value, :lenses => [:random_value] do
            email.random_value * 10
          end

          lens :also_depends_on_random_value, :lenses => [:random_value] do
            email.random_value * 100
          end

          router :root, :lenses => [:random_spam_value] do
            if email.random_spam_value > 0.5
              send_to :other_router
            else
              send_to :bitbucket
            end
          end

          router :other_router, :lenses => [:also_depends_on_random_value] do
            send_to :place
          end
        end
      }.should_not raise_error
    end
  end
end
