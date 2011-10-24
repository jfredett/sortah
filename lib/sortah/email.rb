require 'delegate'
require 'mail'
module Sortah
  class Email < DelegateClass(Mail)
    def self.wrap(context, metadata = {})
      Email.new(context, metadata)
    end

    def method_missing(meth, *args, &blk)
      return @metadata[meth] if has_data_for?(meth)
      super rescue nil
    end

    def metadata(key, value)
      @metadata[key] = value
    end

    private

    def has_data_for?(meth)
      @metadata.keys.include?(meth) and 
      @metadata[meth] != :pass_through 
    end

    def initialize(context, metadata)
      @metadata = metadata
      super(context)
    end

  end
end
