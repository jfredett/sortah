require './lib/sortah/destination'
require 'singleton'
module Sortah
  class Parser
    include Singleton

    attr_reader :maildir

    def maildir(maildir_path = nil)
      @maildir = maildir_path if maildir_path
      @maildir
    end

    def email
      
    end

    def clear
      @destinations = Destinations.new
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

    def destination(name, args)
      @destinations[name] = args 
    end

    def destinations
      @destinations
    end
  end
end
