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

    def process(lens)
      return unless @metadata[lens.name].nil?
      if lens.provides_value? 
        @metadata[lens.name] = run!(lens.block)
      else 
        run!(lens.block)
        @metadata[lens.name] = :pass_through
      end
    end

    private

    def has_data_for?(meth)
      @metadata.keys.include?(meth) and 
      @metadata[meth] != :pass_through 
    end

    def email
      self 
    end

    def run!(block)
      self.instance_eval &block
    end

    def initialize(context, metadata)
      @metadata = metadata
      super(context)
    end

  end
end
