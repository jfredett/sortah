require 'spec_helper'

describe Sortah::Handler do
  context "when building the handler" do
    it "should ask for the parsed content" do
      context = mock(:context)
      context.should_receive(:destinations).and_return(instance_of(Sortah::Destinations))
      context.should_receive(:lenses).and_return(instance_of(Sortah::Lenses))
      context.should_receive(:routers).and_return(instance_of(Sortah::Routers))
      context.should_receive(:maildir).and_return(instance_of(String))
      context.should_receive(:error_dest).and_return(instance_of(String))
      context.should_receive(:type).and_return(instance_of(Symbol))

      Sortah::Handler.build_from(context)
    end
  end
end

