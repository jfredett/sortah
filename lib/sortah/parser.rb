require './lib/sortah/destination'
require './lib/sortah/lens'

require 'singleton'
module Sortah
  class Parser
    include Singleton

    ##object-level interaction
    
    def clear
      @destinations = Destinations.new
      @lenses = Lenses.new
      @routers = {}
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
      @destinations.valid?
    end
   
    # TODO: refactor the below to some modules which get
    # mixed in -- Sortah::Language::{Config,Elements}

    ## metadata/config data
    
    attr_reader :maildir

    def maildir(maildir_path = nil)
      @maildir = maildir_path if maildir_path
      @maildir
    end

    def destinations
      @destinations
    end

    ## language elements
    def destination(name, args)
      @destinations[name] = args 
    end

    def lens(name, opts = {}, &block)
      @lenses[name] = Lens.new(name, opts, block)
    end

    def router(name = :root, opts = {}, &block)
      raise ParseErrorException if @routers[name]
      @routers[name] = [name, opts, block]
    end
  end
end
