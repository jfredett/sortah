require 'sortah/util/component_collection'

module Sortah
  class Destinations < ComponentCollection
    def [](key)
      value = self.fetch(key)
      if value.alias? 
        self.fetch(value.path)
      else
        value
      end
    end
  end

  class Destination
    attr_reader :name, :path

    def self.dynamic(path)
      Destination.new(nil, path)
    end

    def initialize(name, path)
      @name = name
      @path = if path.class == Hash then path[:abs] else path end
    end

    def defined?(context)
      context.include?(@name)
    end

    def alias?
      @path.class == Symbol
    end

    def ==(other)
      (other.class == Destination && other.name == @name && other.path == @path) ||
      @path == other || 
      super
    end

    def to_s
      @path
    end
  end
end
