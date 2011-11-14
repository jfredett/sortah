module Sortah

  class FinishedExecution < Exception
  end
  
  
  class CleanRoom < Object
    def self.sort(email, context)
      new(email, context).sort
    end

    def sort
      catch(:finished_execution) { run!(@pointer) } until @pointer.is_a?(Destination)
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
      @pointer = if dest.is_a? Hash
        Destination.dynamic(dest[:dynamic])
      else
        @__context__.routers[dest] || @__context__.destinations[dest]
      end
      throw :finished_execution 
    end

    def initialize(email, context)
      @__email__ = Email.wrap(email)
      @__context__ = context
      @pointer = context.routers[:root]
    end
  end
end
