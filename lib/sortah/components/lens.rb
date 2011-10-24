require 'sortah/util/component_collection'
require 'sortah/util/component'

module Sortah
  class Lenses < ComponentCollection
    def clear_state!
      self.each_value { |lens| lens.clear_state! }
    end
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

    def clear_state!; @ran = false; end
  end
end
