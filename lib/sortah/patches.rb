module Kernel
  def sortah(&block)
    instance = Sortah::Parser.instance
    instance.handle &block if block_given? 
    Sortah::Handler.build_from(instance)
  end
end
