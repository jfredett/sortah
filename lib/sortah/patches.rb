module Kernel
  def sortah(&block)
    if block_given?
      Sortah::Parser.instance.handle &block 
    else 
      Sortah::Parser.instance
    end
  end
end
