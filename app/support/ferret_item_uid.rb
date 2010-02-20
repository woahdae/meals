class FerretItemUID
  def self.search_by_name(term)
    return [] if term.blank?
    Gaston::Index.ferret_search(make_query(term))
  end
  
  # makes something like
  # "(name:\"Green Eggs\"^100.0  (first_word_in_name:Green^50.0 name:Green~0.7) (name:Eggs^50.0 name:Eggs~0.7))"
  def self.make_query(term)
    query = "name:#{term}"
    term.split(" ").each do |t|
      query << " (name:#{t}^50 first_word_in_name:#{t.singularize}^100)"
    end
    query
  end
end