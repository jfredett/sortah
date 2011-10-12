require './lib/sortah/destination'
require 'singleton'
module Sortah
  class Parser
    include Singleton

    ##object-level interaction

    def clear
      @destinations = Destinations.new
      @lenses = {}
    end

    def initialize
      clear
    end

    def result
      self.class.instance
    end
    
    def handle(&block)
      self.instance_eval &block
    end

    # TODO: refactor the below to some modules which get
    # mixed in -- Sortah::Language::{Config,Elements}

    ## metadata/config data

    attr_reader :maildir

    def maildir(maildir_path = nil)
      @maildir = maildir_path if maildir_path
      @maildir
    end

    def email

    end

    ## language elements
    def destination(name, args)
      raise ParseErrorException if @destinations[name]
      @destinations[name] = args 
    end

    def destinations
      @destinations
    end

    def lens(name, opts = {})
    end
  end
end
