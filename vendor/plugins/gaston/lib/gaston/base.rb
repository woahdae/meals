module Gaston
  module Base
    def define_index(database = "default")
      index = Gaston::Index.instance(database)
      yield ClassNameProxy.new(index, self.name)

      define_method :ferret_class do
        self.class.name
      end
      index.indexed_classes << self
    end

    def search(term, options = {})
      Gaston::Index.search(self.name,
                           "+ferret_class:#{self.name} +(#{term})",
                           options)
    end
  end
end
