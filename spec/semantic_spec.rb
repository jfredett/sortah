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
    Sortah::Parser.clear!
  end

  context "when sorting an email" do

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
      context "when using sortah#sort, " do
        subject { basic_sortah_definition; sortah.sort(@email) }
        it { should respond_to :destination }
        it { should respond_to :metadata } 

        subject { basic_sortah_definition; sortah }
        it "should sort emails based on the sortah definitions" do
          subject.sort(@email).destination.should == "foo/"
          subject.sort(@reply_email).destination.should == "bar/"
        end
      end

      it "should defer to a second router if it is sent to one" do
        sortah do
          destination :foo, "foo/"
          destination :bar, "bar/"
          
          router do
            if email.from.any? { |sender| sender =~ /chuck/ }
              send_to :foo
            else
              send_to :secondary_router
            end
          end

          router :secondary_router do
            send_to :bar
          end
        end
        
        sortah.sort(@email).destination.should == "foo/"
        sortah.sort(@reply_email).destination.should == "bar/"
      end

      it "should defer to a second router using the more idiomatic ruby syntax" do
        sortah do
          destination :foo, "foo/"
          destination :bar, "bar/"
          
          router do
            send_to :foo if email.from.any? { |sender| sender =~ /chuck/ }
            send_to :secondary_router
          end

          router :secondary_router do
            send_to :bar
          end
        end
        sortah.sort(@email).destination.should == "foo/"
        sortah.sort(@reply_email).destination.should == "bar/"
      end

      it "should allow me to set local variables in a router block" do
        sortah do
          destination :foo, "foo/"
          destination :bar, "bar/"
          
          router do
            senders = email.from

            send_to :foo if senders.any? { |sender| sender =~ /chuck/ }
            send_to :secondary_router
          end

          router :secondary_router do
            send_to :bar
          end
        end
        sortah.sort(@email).destination.should == "foo/"
        sortah.sort(@reply_email).destination.should == "bar/"
      end
      
      it "should run dependent lenses for the root router" do
        sortah do
          destination :foo, "foo/"
         
          lens :senders do
            email.from.map { |s| s.split('@').first }
          end

          router :root, :lenses => [:senders] do
            send_to :foo
          end
        end
        sortah.sort(@email).metadata(:senders).should == ["chuck"]
      end

      it "should run dependent lenses for the non-root router, but only if the router gets called" do
        sortah do
          destination :foo, "foo/"
         
          lens :senders do
            email.from.map { |s| s.split('@').first }
          end

          lens :never_called do
            "This should never be called, since the router that depends on it never gets called"
          end

          router :root, :lenses => [:senders] do
            send_to :foo
          end

          router :bar, :lenses => [:never_called] do
            "doesn't matter what I put in here"
          end
        end
        sortah.sort(@email).metadata(:never_called).should be_nil
      end

      it "should never run a lens that isn't a dependency" do
        sortah do
          destination :foo, "foo/"
         
          lens :senders do
            email.from.map { |s| s.split('@').first }
          end

          lens :never_called do
            "This should never be called, since the router that depends on it never gets called"
          end

          router :root, :lenses => [:senders] do
            send_to :foo
          end
        end
        sortah.sort(@email).metadata(:never_called).should be_nil
      end

      it "should run provide access to the metadata generated by a lens through the email object" do
        sortah do
          destination :foo, "foo/"
          destination :bar, "bar/"
         
          lens :senders do
            email.from.map { |s| s.split('@').first }
          end

          lens :never_called do
            "This should never be called, since the router that depends on it never gets called"
          end

          router :root, :lenses => [:senders] do
            if email.senders.include? "chuck"
              send_to :foo
            else
              send_to :bar
            end
          end
        end
        sortah.sort(@email).destination.should == "foo/"
        sortah.sort(@reply_email).destination.should == "bar/"
      end

      it "should run subdependencies of lenses" do
        sortah do
          destination :foo, "foo/"
          destination :bar, "bar/"
         
          lens :senders, :lenses => [:sub_dep] do
            email.from.map { |s| s.split('@').first }
          end

          lens :sub_dep do
            "Sub Dep Ran"
          end

          router :root, :lenses => [:senders] do
            if email.senders.include? "chuck"
              send_to :foo
            else
              send_to :bar
            end
          end
        end
        sortah.sort(@email).metadata(:sub_dep).should == "Sub Dep Ran"
      end

      it "should not run the same lens twice" do
        $count = 0 #evil, pure evil
        sortah do
          destination :bar, "bar/"
         
          lens :inc do
            $count += 1
          end

          router :root, :lenses => [:inc] do
            send_to :baz
          end

          router :baz, :lenses => [:inc] do
            send_to :bar
          end
        end

        sortah.sort(@email).metadata(:inc).should == 1

        $count = nil #undefine $count
      end

      it "should not set any metadata for a :pass_through lens" do
        sortah do
          destination :foo, "foo/"
         
          lens :passthrough, :pass_through => true do
            "some external service call"
          end

          router :root, :lenses => [:passthrough] do
            send_to :baz
          end

          router :baz, :lenses => [:passthrough] do
            send_to :foo
          end
        end
        sortah.sort(@email).metadata(:passthrough).should be_nil
      end

      it "should not run a pass_through lens more than once" do
        $count = 0
        sortah do
          destination :foo, "foo/"
         
          lens :passthrough, :pass_through => true do
            $count += 1
          end

          router :root, :lenses => [:passthrough] do
            send_to :baz
          end

          router :baz, :lenses => [:passthrough] do
            send_to :foo
          end
        end
        sortah.sort(@email)
        $count.should == 1
      end

      it "should execute only until the first #send_to call" do
        sortah do 
          destination :foo, "foo/"
          router do
            send_to :foo
            throw Exception
          end
        end
        expect { sortah.sort(@email) }.should_not raise_error Exception
        sortah.sort(@email).destination.should == "foo/"
      end

      describe "#full_destination" do
        it "should return the full path (including the maildir basepath) to which an email will be routed" do
          sortah do 
            maildir '/tmp/'
            destination :foo, "foo/"
            router do
              send_to :foo
            end
          end
          sortah.sort(@email).full_destination.should == "/tmp/foo/"
        end

        it "should return the correct path when using a dynamic destination" do
          sortah do
            maildir '/tmp/'
            router do
              send_to :dynamic => "foo.bar.baz"
            end
          end
          sortah.sort(@email).full_destination.should == "/tmp/foo.bar.baz"
        end
      end

    end

  end

  describe "acceptance" do
    it "should be able to parse and sort using a real live example sortah definition" do
    
      sortah do
        load './spec/fixtures/semantic_acceptance/rc'
      end

      personal_email = Mail.new do
        to 'jfredett@place.com'
        from 'sfredett@somewhere.com'
      end

      work_email = Mail.new do
        to 'joe@work.com'
        from 'brian@work.com'
        subject 'You get a raise, you brilliant bastard.'
        #shuttup, I can dream.
      end

      dynamic_email = Mail.new do
        to 'joe@work.com'
        from 'dynamic@work.com'
        subject 'this is a dynamic email'
        #shuttup, I can dream.
      end

      sortah.sort(@email).destination.should == 'new/'
      sortah.sort(personal_email).destination.should == 'personal/sarah/new/'
      sortah.sort(work_email).destination.should == 'work/brian/new/'
      sortah.sort(dynamic_email).destination.should == 'bar'
    end
  end
end
