module Gaston
  class SearchResults
    attr_reader :count
    
    def initialize(count, objects)
      @count = count
      @target = objects
    end

    def method_missing(sym, *args, &block)
      @target.send(sym, *args, &block)
    end
  end
end
