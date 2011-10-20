require 'sortah/util/component_collection'
require 'sortah/util/component'

module Sortah 
  class Routers < ComponentCollection
    def has_root?
      self.fetch(:root, false)
    end
  end

  class Router < Component 
    def has_lens?
      !@opts[:lenses].nil?
    end

    def lenses
      @opts[:lenses]
    end
  end
end
