require 'sortah/components'

require 'singleton'
module Sortah
  class Parser
    include Singleton

    def self.clear!
      self.instance.clear!
    end

    ##object-level interaction
    attr_reader :destinations, :lenses, :routers

    def clear!
      @destinations = Destinations.new
      @lenses = Lenses.new
      @routers = Routers.new
    end

    def initialize
      clear!
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

    ## metadata/config data

    #double-duty getter/setter
    def maildir(maildir_path = nil)
      @maildir = maildir_path if maildir_path
      @maildir
    end

    #double-duty getter/setter
    def error_dest(dest = nil)
      @error_dest = dest if dest
      @error_dest
    end

    #double-duty getter/setter
    def type(type = nil)
      @type = type if type
      @type
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
