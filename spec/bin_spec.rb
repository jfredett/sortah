def run_with(arg, email = "")
  #uses the sortah defn in spec/fixtures/rc
  cmd =<<-CMD
bundle exec bin/sortah #{arg} --rc "spec/fixtures/rc" 2>/dev/null <<-EMAIL
#{email}
EMAIL
CMD
  result = `#{cmd}`

  { result: result, status: $?.to_i }
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

    @failing_email = Mail.new do
      to 'fail@example.com'
      from 'fail@nope.com'
      subject "Taximerdizin'"
      body <<-TXT
          OJAI VALLEY TAXIDERMY

          BET YOU THOUGHT THIS EMAIL WAS REAL

          NOPE. CHUCK TESTA
      TXT
    end
  end

  before :each do
    Sortah::Parser.clear!
  end

  context "when executing in dry-run mode, " do
    it "should have a dry-run mode" do
      cmd = run_with("--dry-run")
      cmd[:result].should =~ /Dry-run mode/
      cmd[:status].should == 0
    end

    it "should not write any files when in dry-run mode" do
      run_with('--dry-run', @email.to_s)
      Dir['/tmp/mail/*'].size.should == 0
    end

    it "should print to STDOUT the location it intends to write the file" do
      run_with('--dry-run', @email.to_s)[:result].
        should =~ %r|writing email to: /tmp/\.mail/foo/|
    end

    it "should write to the destination specified by #error_dest when an exception is raised during sorting" do
      run_with('--dry-run', @failing_email.to_s)[:result].
        should =~ %r|writing email to: /tmp/\.mail/errors/|
    end
    end
  end
end
