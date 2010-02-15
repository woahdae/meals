module Gaston
  class DocumentProxy
    def initialize(target)
      @target = target
    end
    
    def id
      @target[:id]
    rescue
      ""
    end
    
    def method_missing(sym, *args, &block)
      @target[sym]
    rescue
      ""
    end
  end
end
