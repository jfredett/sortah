require 'sortah/util/component_collection'
require 'sortah/util/component'

module Sortah 
  class Routers < ComponentCollection
    def has_root?
      self.fetch(:root, false)
    end
  end

  class Router < Component 
    def run_dependencies!(email, context)
      dependencies(context).each { |l| l.run!(email, context) }
    end
  end
end
