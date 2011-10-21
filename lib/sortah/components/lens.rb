require 'sortah/util/component_collection'
require 'sortah/util/component'

module Sortah
  class Lenses < ComponentCollection
  end

  class Lens < Component

    def provides_value? 
      !@opts[:pass_through]
    end

    def valid?(context)
      dependencies.each do |lens|
        raise ParseErrorException unless context.include? lens
      end
    end

    def run!(email, context)
      dependencies(context).each { |l| l.run!(email, context) }
      email.process(self)
    end
  end
end
