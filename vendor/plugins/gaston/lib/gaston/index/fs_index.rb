module Gaston
  module Index
    class FsIndex < MemoryIndex
      def ferret_index(create = false)
        Ferret::Index::Index.new(:path   => index_path,
                                 :key    => key,
                                 :create => create)
      end

      def index_path
        "#{Rails.root}/tmp/indexes/#{Rails.env}/#{client}"
      end
    end
  end
end
