def run_with(arg, email = "")
   cmd =<<-CMD
   bin/sortah #{arg} <<-EMAIL
   #{email}
   EMAIL
CMD
   result = `#{cmd}`
   { result: result, status: $? }
end


describe "the sortah executable" do
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


  context "when executing in dry-run mode, " do
    it "should have a dry-run mode" do
      cmd = run_with("--dry-run")
      cmd[:result].should =~ /Dry-run mode/
      cmd[:status].should == 0
    end
    it "should not write any files when in dry-run mode" do
      `mkdir -p '/tmp/mail'`
      sortah do
        destination :foo, :abs => "/tmp/mail"
        router do
          send_to :foo
        end
      end
      run_with('--dry-run', @email.to_s)
      Dir['/tmp/mail/*'].size.should == 0
    end
  end
end
