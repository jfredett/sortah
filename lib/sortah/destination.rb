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
      @hash[key] = value
    end
  end
end
