module Gaston
  class DocumentProxy
    def initialize(target)
      @target = target
    end
    
    def id
      @target[:id]
    rescue IOError
      ""
    end
    
    def method_missing(sym, *args, &block)
      @target[sym]
    rescue IOError
      ""
    end
  end
end
