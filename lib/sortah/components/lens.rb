module Sortah
  class Lenses
    def initialize
      @lenses = {}
    end

    def <<(lens)
      #we're already using lens#valid? -- this feels like a hack
      raise ParseErrorException unless @lenses[lens.name].nil? 
      @lenses[lens.name] = lens
    end

    def [](name)
      @lenses[name]
    end

    def valid?
      return if @lenses.empty?
      @lenses.each_value do |lens|
        lens.valid?(@lenses.keys)
      end
    end
  end

  class Lens
    attr_reader :name

    def initialize(name, opts = {}, block)
      @dependencies = opts[:lenses] || []
      @provides_value = opts[:pass_through]
      @name = name
      @definition = block
    end

    def valid?(context)
      @dependencies.each do |lens|
        raise ParseErrorException unless context.include? lens
      end
    end
  end
end
