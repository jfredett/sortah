module Sortah
  class Component 
    attr_reader :name

    def initialize(name, opts = {}, *potential_block) 
      @name = name
      @opts = opts
      @block = potential_block.first if potential_block.size > 0
    end
  
    def defined?(context)
      !!context[name]
    end
  end
  
end
