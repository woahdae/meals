When "I fill in:" do |table|
  table.hashes.each do |row|
    fill_in(row['field'], :with => row['value'])
  end
end

Then /^I should see:$/ do |table|
  table.raw.flatten.each {|text| response.should contain(text)}
end

Then /^I should not see:$/ do |table|
  table.raw.flatten.each {|text| response.should_not contain(text)}
end
