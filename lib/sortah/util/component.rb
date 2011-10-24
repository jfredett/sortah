module Sortah
  class Component 
    attr_reader :name, :block

    def initialize(name, opts = {}, *potential_block) 
      @name = name
      @opts = opts
      @block = potential_block.first unless potential_block.empty?
    end

    def run_dependencies!(email, context)
      dependencies(context).each { |lens| lens.run!(email, context) }
    end

    def defined?(context)
      !!context[name]
    end

    protected 

    def dependencies(context = nil)
      lenses = (@opts[:lenses] || [])
      return lenses if context.nil?
      lenses.map { |lens| context[lens] }
    end
  end
  
end
