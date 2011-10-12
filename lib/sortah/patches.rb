module Kernel
  def sortah(&block)
    Sortah::Parser.instance.handle &block if block_given? 
    Sortah::Parser.instance
  end
end
