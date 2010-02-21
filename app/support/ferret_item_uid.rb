require 'ferret'

class FerretItemUID
  attr_reader :score
  
  ATTRIBUTES = [:name, :id]
  ATTRIBUTES.each {|a| attr_accessor a}
  
  QUERY_LIMIT = 100
  
  def initialize(document, score)
    init_ivars(document)
    @score = score
  end
  
  def init_ivars(document)
    ATTRIBUTES.each {|a| instance_variable_set("@#{a}", document[a])}
  end

  class << self
    def search_by_name(term)
      return [] if term.blank?
      
      results = []
      ferret_index do |f_idx|
        f_idx.search_each(make_query(term), :limit => QUERY_LIMIT) do |doc_id, score|
          results << self.new(f_idx[doc_id], score)
        end
      end
      results
    end
  
    def make_query(term)
      query = "name:#{term}"
      term.split(" ").each do |t|
        query << " (name:#{t.singularize} first_word_in_name:#{t.singularize}^50)"
      end
      query
    end
  
    def ferret_index(options = {}, &block)
      f_idx = Ferret::Index::Index.new({
        :path   => Rails.root + "/tmp/indexes/#{Rails.env}/default",
        :key    => [:ferret_class, :id],
        :create => (options[:create] || false) })
      result = block.call(f_idx)
      f_idx.close
      return result
    end
  
    def rebuild
      ferret_index(:create => true) do |f_idx|
        ItemUID.find_each(:include => :usda_food_description) do |item_uid|
          f_idx << make_document(item_uid)
        end
        f_idx.optimize
      end
    end
    
    def update(record)
      delete(record) unless record.id.nil?
      ferret_index do |f_idx|
        f_idx.add_document(make_document(record))
      end
    end

    def delete(record)
      ferret_index do |f_idx|
        doc_id = nil
        f_idx.search_each("+id:#{record.id}") { |id, _| doc_id = id }
        f_idx.delete(doc_id) if doc_id
      end
    end
    
    def make_document(item_uid)
      {
        :ferret_class => "ItemUID", 
        :id => item_uid.id,
        :name => item_uid.name,
        :first_word_in_name => item_uid.first_word_in_name
      }
    end
  end # class << self
end
