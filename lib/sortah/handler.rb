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

    attr_reader :destinations, :lenses, :routers, :maildir, :error_dest, :type

    def metadata(key)
      @result.metadata(key)
    end

    def destination
      @result.destination
    end

    def full_destination
      maildir + destination.to_s
    end

    def full_error_destination
      maildir + error_dest.to_s
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
      @error_dest   = context.error_dest
      @maildir      = context.maildir
      @type         = context.type
    end
  end
end
