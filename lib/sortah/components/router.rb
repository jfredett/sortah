require 'sortah/util/component_collection'
require 'sortah/util/component'

module Sortah 
  class Routers < ComponentCollection
    def has_root?
      self.fetch(:root, false)
    end
  end

  class Router < Component 

    def run_lenses!(email, context)
      lenses.each { |l| context[l].run!(email) }
    end

    private

    def lenses
      @opts[:lenses] || []
    end
  end
end
