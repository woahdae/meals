class FerretItemUID
  def self.search_by_name(term)
    return [] if term.blank?
    Gaston::Index.ferret_search(make_query(term))
  end
  
  # makes something like
  # "(name:\"Green Eggs\"^100.0  (first_word_in_name:Green^50.0 name:Green~0.7) (name:Eggs^50.0 name:Eggs~0.7))"
  def self.make_query(term)
    term.split(/\s+/).inject("(name:\"#{term.singularize}\"~0.7^100 ") do |full, subterm|
      full << " (first_word_in_name:#{subterm.singularize}^50.0 name:#{subterm.singularize}~0.7)"
    end << ")"
  end
end