module Sortah
  class Destinations 
    def initialize
      @hash = {}
    end

    def [](key)
      value = @hash[key]
      case value
        when Symbol
          @hash[value]     
        when Hash
          value[:abs]
        else
          value
      end
    end

    def []=(key, value)
      raise ParseErrorException if @hash[key]
      @hash[key] = value
    end

    def valid?
    end
  end

  class Destination
    attr_reader :name, :path

    def initialize(name, path)
      @name = name
      @path = path
    end

    def valid?(context)
      raise ParseErrorException if context.include?(name)
    end

    def ==(other)
      (other.class == Destination && other.name == @name && other.path == @path) ||
      @path == other || 
      super
    end
  end
end
