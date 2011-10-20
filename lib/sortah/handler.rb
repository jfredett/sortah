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
        @email.metadata = @metadata
        if @router.has_lens?
          @router.lenses.each do |lens|
            run(lens) 
          end
        end
        self.instance_eval &@router.block
      end
      self
    end

    attr_reader :destinations, :destination, :maildir, :metadata

    private

    attr_reader :email, :routers
    
    def run(key)
      return unless @metadata[key].nil?
      @metadata[key] ||= self.instance_eval &@lenses[key].block 
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
      @metadata = {}
    end
  end
end
