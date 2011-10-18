require 'sortah/util/component_collection'

module Sortah
  class Lenses < ComponentCollection
  end

  class Lens
    attr_reader :name

    def initialize(name, opts = {}, block)
      @dependencies = opts[:lenses] || []
      @provides_value = opts[:pass_through]
      @name = name
      @definition = block
    end

    def defined?(context)
      context.include?(@name)
    end

    def valid?(context)
      @dependencies.each do |lens|
        raise ParseErrorException unless context.include? lens
      end
    end
  end
end
