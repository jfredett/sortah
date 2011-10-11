require './lib/sortah/destination'
module Sortah
  class Parser
    def initialize(&block)
      @destinations = Destinations.new
      self.instance_eval &block
    end

    def destination(name, args)
      @destinations[name] = args 
    end

    def destinations
      @destinations
    end
  end
end
