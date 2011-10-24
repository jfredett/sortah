module Sortah

  class FinishedExecution < Exception
  end
  
  
  class CleanRoom < BasicObject
    def self.sort(email, context)
      new(email, context).sort
    end

    def sort
      until @pointer.is_a?(Destination) do
        run!(@pointer) rescue FinishedExecution
      end 
      self
    end

    def metadata(key)
      email.send(key)
    end

    def destination 
      @pointer if @pointer.is_a? Destination
    end

    private 

    def email; @__email__; end

    def run!(component) 
      @pointer.run_dependencies!(email, @__context__.lenses)
      self.instance_eval &component.block
    end

    def send_to(dest)
      @pointer = @__context__.routers[dest] || @__context__.destinations[dest]
      throw FinishedExecution
    end

    def initialize(email, context)
      @__email__ = Email.wrap(email)
      @__context__ = context
      @pointer = context.routers[:root]
    end
  end
end
