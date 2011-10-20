module Sortah
  class Email 
    attr_accessor :metadata

    def self.wrap(context, metadata = {})
      Email.new(context, metadata)
    end

    def method_missing(meth, *args, &blk)
      if base_respond_to?(meth)
        super
      elsif @mail.respond_to?(meth)
        @mail.send(meth) #access only, no setting
      elsif metadata.keys.include?(meth)
        @metadata[meth]
      end
    end

    alias_method :base_respond_to?, :respond_to?
    def respond_to?(meth)
      base_respond_to?(meth) || @mail.respond_to?(meth)
    end

    def set_metadata(key, block)
      return unless @metadata[key].nil?
      @metadata[key] = self.instance_eval &block 
    end

    private
    def email
      self 
    end

    def initialize(context, metadata)
      @mail = context
      @metadata = metadata
    end

  end
end
