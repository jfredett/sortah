module Kernel
  def sortah(&block)
    Sortah::Parser.instance.handle &block if block_given? 
    Sortah::Handler.build_from(Sortah::Parser.instance)
  end
end
