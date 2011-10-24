require 'sortah/components'
module Sortah
  class Handler
    def self.build_from(context)
      new(context)
    end

    def sort(context)
      raise NoRootRouterException unless @routers.has_root?    
      clear_state!
      @result = CleanRoom.sort(context, self)
      self
    end

    attr_reader :destinations, :lenses, :routers, :maildir

    def metadata(key)
      @result.metadata(key)
    end

    def destination
      @result.destination
    end

    private

    def clear_state! 
      @lenses.clear_state!
    end

    def clear_state! 
      @lenses.clear_state!
    end

    def initialize(context)
      @destinations = context.destinations
      @lenses       = context.lenses
      @routers      = context.routers
      @maildir      = context.maildir
    end
  end
end
