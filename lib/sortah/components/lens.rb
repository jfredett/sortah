require 'sortah/util/component_collection'
require 'sortah/util/component'

module Sortah
  class Lenses < ComponentCollection
  end

  class Lens < Component
    def dependencies
      @opts[:lenses] || []
    end

    def provides_value? 
      !!@opts[:pass_through]
    end

    def valid?(context)
      dependencies.each do |lens|
        raise ParseErrorException unless context.include? lens
      end
    end

    def run!(context)
      context.set_metadata(name, block)
    end
  end
end
