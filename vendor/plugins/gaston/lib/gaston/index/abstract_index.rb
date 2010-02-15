module Gaston
  module Index
    class AbstractIndex
      attr_accessor :client, :indexed_classes

      def rebuild()
        idx = ferret_index(true)
        with_ferret_index(idx) do |f_idx|
          indexed_classes.each do |clazz|
            clazz.find_each(@finder_options[clazz.name]) do |record|
              f_idx << make_document(record)
            end
          end
          f_idx.optimize
        end
      end
      
      def ferret_search(query, use_proxy = false)
        return [] if query.blank?
        
        results = []
        with_ferret_index do |f_idx|
          f_idx.search_each(query, :limit => 500) do |doc_id, score|
            if use_proxy
              results << DocumentProxy.new(f_idx[doc_id])
            else
              results << f_idx[doc_id][:id]
            end
          end
        end
        results
      end
      
      def search(classname, query, options = {})
        results = ferret_search(query)
        return SearchResults.new(0, results) if results.empty?

        clazz = classname.constantize
        options = @finder_options[classname].merge(options).merge( 
          :order => "#{clazz.primary_key}=#{results.reverse.join(", #{clazz.primary_key}=")}",
          :conditions => { clazz.primary_key => results } )
        objs = clazz.find(:all, options)
        SearchResults.new(results.size, objs)
      end

      def update(record)
        with_ferret_index do |f_idx|
          f_idx.add_document(make_document(record))
        end
      end

      def delete(record)
        with_ferret_index do |f_idx|
          doc_id = find_by_key(f_idx, record)
          f_idx.delete(doc_id)
        end
      end

      def fields(classname, field_list)
        field_list.each do |field|
          unless @fields[classname].include?(field)
            @fields[classname] << field
          end
        end
      end
      
      def finder_options(classname, options_hash)
        @finder_options[classname] = options_hash
      end

      def initialize(client)
        @client = client
        @fields = Hash.new { |h, k| h[k] = [] }
        @finder_options = Hash.new { |h, k| h[k] = {} }
        @indexed_classes = []
      end

      def key
        [:ferret_class, :id]
      end

      def ferret_index(create = false)
        raise NotImplementedError, "You must override ferret_index() in a subclass"
      end

      protected

      def find_by_key(f_idx, record)
        if (key.instance_of?(Array))
          query = key.inject("") { |q, f| q << "+#{f}:#{record.send(f)} " }
        else
          query = "+#{key}:#{record.send(key)}"
        end
        doc_id = nil
        f_idx.search_each(query) { |id, _| doc_id = id }
        doc_id
      end

      def make_document(record)
        @fields[record.class.name] ||= []
        document = @fields[record.class.name].inject({}){ |h, f| h[f] = record.send(f); h }
        document[:ferret_class] = record.class.name
        document[:id] = record.id
        document
      end

      def with_ferret_index(idx = nil)
        f = idx || ferret_index
        yield f
        f.close
      end
    end
  end
end
