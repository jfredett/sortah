module Sortah
  class Email 
    def self.wrap(context)
      @mail = context      
    end
  

    def method_missing(meth, *args, &blk)
      if base_respond_to? meth
        super
      else
        @mail.send(meth, args, &blk)
      end
    end

    alias_method :base_respond_to?, :respond_to?
    def respond_to?(meth)
      base_respond_to?(meth) || @mail.respond_to?(meth)
    end
  end
end
