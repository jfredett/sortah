require 'sortah/util/component_collection'

module Sortah 
  class Routers < ComponentCollection
  end

  class Router 
    attr_reader :name

    def initialize(name, opts, block)
      @name = name
      @opts = opts
      @block = block
    end

    def defined?(context)
      context[@name]
    end
  end
end
