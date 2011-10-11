module Sortah
  class Parser
    attr_reader :destinations

    def initialize(&block)
      @destinations = {}
      self.instance_eval &block
    end

    def destination(name, *args)
      @destinations[name] = args
    end

  end
end
