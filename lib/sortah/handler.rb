require 'sortah/components'
module Sortah
  class Handler
    def self.build_from(context)
      new(context)
    end

    attr_reader :destinations, :maildir

    def sort(email)
      raise NoRootRouterException unless @routers.has_root?    
      self
    end

    def destination
      "foo/"
    end

    private

    def initialize(context)
      @destinations = context.destinations
      @lenses = context.lenses
      @routers = context.routers
      @maildir = context.maildir
    end
  end
end
