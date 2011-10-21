require 'sortah/components'
module Sortah
  class Handler
    def self.build_from(context)
      new(context)
    end

    def sort(context)
      raise NoRootRouterException unless @routers.has_root?    
      
      @router = routers[:root]
      @email = Sortah::Email.wrap(context)
      
      until @found_destination
        @router.run_dependencies!(email, lenses)
        run!(@router.block) #updates @router via a `send_to` call
      end
      self
    end

    attr_reader :destinations, :destination, :maildir

    def metadata(key)
      email.send(key)
    end

    private

    attr_reader :email, :lenses, :routers

    def run!(block)
      self.instance_eval &block
    end

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
