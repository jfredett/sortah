module Sortah
  class Component 
    attr_reader :name, :block

    def initialize(name, opts = {}, *potential_block) 
      @name = name
      @opts = opts
      @block = potential_block.first if potential_block.size > 0
    end

    def run_dependencies!(email, context)
      dependencies(context).each { |l| l.run!(email, context) }
    end

    def defined?(context)
      !!context[name]
    end

    protected 

    def dependencies(context = nil)
      lenses = (@opts[:lenses] || [])
      return lenses if context.nil?
      lenses.map { |l| context[l] }
    end
  end
  
end
