require 'sortah/components'
module Sortah
  class Handler
    def self.build_from(context)
      new(context)
    end

    def sort(context)
      @email = context
      raise NoRootRouterException unless @routers.has_root?    
      self.instance_eval &@routers[:root].block
      self
    end

    attr_reader :destinations, :destination, :maildir

    private

    attr_reader :email

    def send_to(dest)
      @destination = destinations[dest]
    end

    def initialize(context)
      @destinations = context.destinations
      @lenses = context.lenses
      @routers = context.routers
      @maildir = context.maildir
    end
  end
end
