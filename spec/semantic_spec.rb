require 'spec_helper'
require 'mail'

#TODO: Move to spec_helper?
def basic_sortah_definition
  sortah do
    maildir "/home/jfredett/.mail"
    destination :foo, "foo/"
    destination :bar, "bar/"
    router do
      if email.from.any? { |sender| sender =~ /chuck/ } 
        send_to :foo
      else
        send_to :bar
      end
    end
  end
end

describe Sortah do
  context "when sorting an email" do
    before :all do
      Mail.defaults do
        delivery_method :test
      end

      @email = Mail.new do
        to 'testa@example.com'
        from 'chuck@nope.com'
        subject "Taximerdizin'"
        body <<-TXT
          OJAI VALLEY TAXIDERMY

          BET YOU THOUGHT THIS EMAIL WAS REAL

          NOPE. CHUCK TESTA
        TXT
      end

      @reply_email = Mail.new do
        to 'chuck@nope.com'
        from 'jgf@somewhere.com'
        subject "Re: Taximerdizin'"
        reply_to 'chuck@nope.com'
        body <<-TXT
        > OJAI VALLEY TAXIDERMY
        >
        > BET YOU THOUGHT THIS EMAIL WAS REAL
        >
        > NOPE. CHUCK TESTA

        Do you taxidermize pets? 
        TXT
      end
    end

    before :each do
      Sortah::Parser.clear
    end

  
    it "should provide a way to sort a single email" do
      sortah.should respond_to :sort
    end

    it "should throw a sematic error when calling #sort with no root router is provided" do
      sortah do 
        destination :foo, "foo/"
        router :not_root do
          send_to :foo
        end
      end
      expect { sortah.sort(@email) }.should raise_error Sortah::NoRootRouterException
    end

    describe "#sort" do
      it "should return an object which responds to #destination" do
        basic_sortah_definition
        sortah.sort(@email).should respond_to :destination
      end
      
      it "should sort emails based on the sortah definitions" do
        basic_sortah_definition
        sortah.sort(@email).destination.should == "foo/"
        sortah.sort(@reply_email).destination.should == "bar/"
      end
    end

  end
end
