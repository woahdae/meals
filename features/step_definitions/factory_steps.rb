Given /^There are existing ([\w_]*)s with:$/ do |factory, table|
  table.hashes.each_with_index do |attrs, i| 
    find_ivars(attrs)
    instance_variable_set("@#{factory}#{i == 0 ? nil : i}", Factory.create(factory, attrs))
  end
end

Given /^There is an existing ([\w_]*)( with (.*))?$/ do |factory, _, attributes|
  attributes = attributes.try(:to_hash_from_story) || {}
  find_ivars(attributes)
  instance_variable_set("@#{factory}", Factory.create(factory, attributes))
end

Given /^There is an existing ([\w_]*) with:$/ do |factory, table|
  instance_variable_set("@#{factory}", Factory.create(factory, table.rows_hash))
end

# if a value is "@blah" it'll set it to the value of @blah.
# helps with associations
def find_ivars(attrs)
  attrs.keys.each {|k| attrs[k] = instance_variable_get(attrs[k]) if attrs[k].match(/^@[\w_0-9]+/)}
end