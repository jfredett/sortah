module Sortah
  class ParseErrorException < Exception
    alias_method :to_s, :inspect
    def inspect
      "<Sortah::ParseErrorException>"
    end
  end

  class NoRootRouterException < Exception
    alias_method :to_s, :inspect
    def inspect
      "<Sortah::NoRootRouterException>"
    end
  end
end
