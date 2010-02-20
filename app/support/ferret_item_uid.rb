class FerretItemUID
  def self.search_by_name(term)
    return [] if term.blank?
    Gaston::Index.ferret_search(make_query(term))
  end
  
  def self.make_query(term)
    query = "name:#{term}"
    term.split(" ").each do |t|
      query << " (name:#{t}^50 first_word_in_name:#{t.singularize}^100)"
    end
    query
  end
end