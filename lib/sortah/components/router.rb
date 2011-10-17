module Sortah 
  class Routers
    def initialize
      @hash = {}
    end

    def [](arg)
      @hash[arg]    
    end

    def <<(router)
      raise ParseErrorException unless router.valid?(@hash)
      @hash[router.name] = router 
    end
    
  end

  class Router 
    attr_reader :name

    def initialize(name, opts, block)
      @name = name
      @opts = opts
      @block = block
    end

    def valid?(context)
      context[@name].nil?
    end
  end
end
