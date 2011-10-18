require 'sortah/components'

require 'singleton'
module Sortah
  class Parser
    include Singleton

    ##object-level interaction
    
    def clear
      @destinations = Destinations.new
      @lenses = Lenses.new
      @routers = Routers.new
    end

    def initialize
      clear
    end

    def result
      self.class.instance
    end
    
    def handle(&block)
      self.instance_eval &block
      valid?
    end

    def valid?
      @lenses.valid?
      @routers.valid?
      @destinations.valid?
    end
   
    # TODO: refactor the below to some modules which get
    # mixed in -- Sortah::Language::{Config,Elements}

    ## metadata/config data
    
    attr_reader :maildir, :destinations

    def maildir(maildir_path = nil)
      @maildir = maildir_path if maildir_path
      @maildir
    end

    ## language elements
    def destination(name, args)
      @destinations << Destination.new(name, args)
    end

    def lens(name, opts = {}, &block)
      @lenses << Lens.new(name, opts, block)
    end

    def router(name = :root, opts = {}, &block)
      @routers << Router.new(name, opts, block)
    end
  end
end
