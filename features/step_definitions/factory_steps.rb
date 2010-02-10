Given /There is an existing ([\w_]*) with:/ do |factory, table|
    table.hashes.each_with_index do |attrs, i| 
      # if a value is "@blah" it'll set it to the value of @blah.
      # helps with associations
      attrs.keys.each {|k| attrs[k] = instance_variable_get(attrs[k]) if attrs[k].match(/^@[\w_0-9]+/)}
      
      instance_variable_set("@#{factory}#{i == 0 ? nil : i}", Factory.create(factory, attrs))
    end
end

Given /There is an existing ([\w_]*) with (.*)/ do |factory, attributes|
  attributes = attributes.try(:to_hash_from_story) || {}
  instance_variable_set("@#{factory}", Factory.create(factory, attributes))
end
