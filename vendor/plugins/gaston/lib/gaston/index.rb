require 'gaston/index/abstract_index'
require 'gaston/index/memory_index'
require 'gaston/index/fs_index'

module Gaston
  module Index
    class << self
      attr_writer :index_type

      def instance(index_name)
        index = store[index_name]
        if index.nil?
          index = index_type.new(index_name)
          store[index_name] = index
        end
        index
      end

      def store
        @store ||= {}
      end

      def rebuild(index_name = "default")
        instance(index_name).rebuild
      end

      def index_type
        @index_type ||= FsIndex
      end

      def update(record, index_name = "default")
        instance(index_name).update(record)
      end

      def delete(record, index_name = "default")
        instance(index_name).delete(record)
      end
      
      def ferret_search(term, index_name = "default")
        instance(index_name).ferret_search(term, true)
      end
      
      def search(classname, query, options = {}, index_name = "default")
        instance(index_name).search(classname, query, options)
      end
    end
  end
end
