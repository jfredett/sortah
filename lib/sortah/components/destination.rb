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

    def <<(dest)
      dest.valid?(@hash)
      @hash[dest.name] = if dest.alias? then @hash[dest.path] else dest end
    end

    def valid?
      true #there is no way to construct an invalid set of destinations
    end
  end

  class Destination
    attr_reader :name, :path

    def initialize(name, path)
      @name = name
      @path = if path.class == Hash then path[:abs] else path end
    end

    def valid?(context)
      #test for validity on insertion
      raise ParseErrorException if context.include?(name)
    end

    def ==(other)
      (other.class == Destination && other.name == @name && other.path == @path) ||
      @path == other || 
      super
    end

    def alias?
      @path.class == Symbol
    end
  end
end
