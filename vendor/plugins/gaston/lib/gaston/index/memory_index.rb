module Gaston
  module Index
    class MemoryIndex < AbstractIndex
      def ferret_index(create = false)
        Ferret::Index::Index.new(:key => key, :create => create)
      end
    end
  end
end
