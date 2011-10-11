module Kernel
  def sortah(&block)
    Sortah::Parser.new &block
  end
end
