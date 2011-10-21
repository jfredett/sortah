require 'spec_helper'
describe Sortah::Email do
  before :each do
    @email = Sortah::Email.wrap(Mail.new)
  end

  it "should proxy the Mail class" do
    (Mail.new.methods - Object.methods).each do |method|
      @email.should respond_to method
    end
  end
end

