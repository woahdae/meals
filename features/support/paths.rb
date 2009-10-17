module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the homepage/
      '/'
    when /make a new recipe/
      "/recipes/new"
    when /^edit the (\w+)$/
      factory_model = instance_variable_get("@#{$1}")
      "/recipes/#{factory_model.id}/edit"
      
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))
    when /the page for the new recipe/
      "/recipes/#{Recipe.last}"
    else
      page_name
    end
  end
end

World(NavigationHelpers)
