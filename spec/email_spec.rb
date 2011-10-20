require 'spec_helper'
describe Sortah::Email do
  it "should proxy the Mail class" do
    @email = Sortah::Email.wrap(Mail.new)
    (Mail.new.methods - Object.methods).each do |method|
      @email.should respond_to method
    end
  end
end

