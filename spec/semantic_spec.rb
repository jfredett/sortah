require 'spec_helper'
require 'mail'

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
    end
  
    it "should provide a way to sort a single email" do
      sortah.should respond_to :sort
    end

  end
end
