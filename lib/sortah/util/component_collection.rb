module Sortah
  class ComponentCollection < Hash
    def <<(component)
      return unless component.respond_to? :name
      raise ParseErrorException if component.defined?(self)
      self[component.name] = component
    end

    def valid?
      return if self.empty?
      self.each_value do |value|
        # someone might have registered a singleton method? 
        next unless value.respond_to? :valid? 
        value.valid?(self)
      end
    end
  end
end
