require 'sortah/util/component_collection'
require 'sortah/util/component'

module Sortah
  class Lenses < ComponentCollection
    def clear_state!
      self.each_value { |lens| lens.clear_state! }
    end
  end

  class Lens < Component
    def provides_value? 
      !@opts[:pass_through]
    end

    def valid?(context)
      dependencies.each do |lens|
        raise ParseErrorException unless context.include? lens
      end
    end

    def run!(email, context)
      @email = email
      return if already_ran?
      run_dependencies!(email, context)
      result = run_block!
      email.metadata(name, result) if provides_value?
    end

    def clear_state!; @ran = false; end

    private 

    def mark_as_run!; @ran = true end
    def already_ran?; @ran end

    # used for context evaluation
    def email; @email; end

    def provides_value? 
      !@opts[:pass_through]
    end

    def run_block!
      mark_as_run!
      self.instance_eval &block
    end
  end
end
