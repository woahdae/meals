#
# Where to go
#

#
# GET
# Go to a given page.
When "$actor goes to $path" do |actor, path|
  case path
  when 'the home page' then visit '/'
  else                      visit path
  end
end

# POST -- Ex:
#   When she creates a book with ISBN: '0967539854' and comment: 'I love this book' and rating: '4'
#   When she creates a singular session with login: 'reggie' and password: 'i_haxxor_joo'
# Since I'm not smart enough to do it right, explicitly specify singular resources
When /^(\w+) creates an? ([\w ]+) with ([\w: \',]+)$/ do |actor, resource, attributes|
  attributes = attributes.to_hash_from_story
  if resource =~ %r{singular ([\w/]+)}
    resource = $1.downcase.singularize
    page.driver.process(:post, "/#{resource}", attributes)
  else
    page.driver.process(:post, "/#{resource.downcase.pluralize}", { resource.downcase.singularize => attributes })
  end
end
