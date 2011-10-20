require 'sortah/components'
module Sortah
  class Handler
    def self.build_from(context)
      new(context)
    end

    def sort(context)
      raise NoRootRouterException unless @routers.has_root?    
      @router = routers[:root]
      @email = context
      
      until @found_destination
        self.instance_eval &@router.block
      end

      self
    end

    attr_reader :destinations, :destination, :maildir

    private

    attr_reader :email, :routers

    def send_to(dest)
      if destinations.defined?(dest)
        @destination = destinations[dest]
        @found_destination = true 
      else
        @router = routers[dest]
      end
      @destination
    end

    def initialize(context)
      @destinations = context.destinations
      @lenses = context.lenses
      @routers = context.routers
      @maildir = context.maildir
    end
  end
end
