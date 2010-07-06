#
# What you should see when you get there
#

#
# Destinations.  Ex:
#   She should be at the new kids page
#   Tarkin should be at the destroy alderaan page
#   The visitor should be at the '/lolcats/download' form
#   The visitor should be redirected to '/hi/mom'
#
# It doesn't know anything about actual routes -- it just
# feeds its output to render_template or redirect_to
#
Then "$actor should be at $path" do |_, path|
  expected = URI.join("http://www.example.com", grok_path(path)).to_s
  current_url.should == expected
end

Then "$actor should be redirected to $path" do |_, path|
  expected = URI.join("http://www.example.com", grok_path(path)).to_s
  current_url.should == expected
end

Then "the page should look AWESOME" do
  page.should have_selector('head title')
  page.should have_selector('h1')
  # page.should be_valid_xhtml
end

#
# Tags
#

Then "the page should contain '$text'" do |_, text|
  page.should have_text(/#{text}/)
end

# please note: this enforces the use of a <label> field
Then "$actor should see a <$container> containing a $attributes" do |_, container, attributes|
  attributes = attributes.to_hash_from_story
  page.should have_selector(container) do |container|
    attributes.each do |tag, label|
      case tag
      when "textfield"
        container.should have_selector("input", :type => 'text')
        container.should have_selector("label") {|l| l.should contain(label)}
      when "password"
        container.should have_selector("input", :type => 'password')
        container.should have_selector("label") {|l| l.should contain(label)}
      when "submit"
        container.should have_selector("input", :type => 'submit', :value => label)
      else
        container.should have_selector(tag) {|t| t.should contain(label)}
      end
    end
  end
end

# please note: this enforces the use of a <label> field
Then "$actor should see a <$container> containing:" do |_, container, table|
  page.should have_selector(container) do |container|
    table.hashes.each do |row|
      tag, label = row['tag'], row['label']
      case tag
      when "textfield"
        container.should have_selector("input", :type => 'text')
        container.should have_selector("label") {|l| l.should contain(label)}
      when "password"
        container.should have_selector("input", :type => 'password')
        container.should have_selector("label") {|l| l.should contain(label)}
      when "submit"
        container.should have_selector("input", :type => 'submit', :value => label)
      else
        container.should have_selector(tag) {|t| t.should contain(label)}
      end
    end
  end
end

#
# Flash messages
#

Then /^(s?he|I) should +see an? (\w+) message ['"]([\w !\']+)['"]$/ do |_, notice, message|
  page.should have_flash(notice, %r{#{message}})
end

Then "$actor should not see $an $notice message '$message'" do |_, _, notice, message|
  have_no_flash(notice, %r{#{message}})
end

Then "$actor should see no messages" do |_|
  ['error', 'warning', 'notice'].each do |notice|
    have_no_flash(notice)
  end
end

RE_POLITENESS = /(?:please|sorry|thank(?:s| you))/i
Then %r{we should be polite about it} do
  page.should have_tag("div.error,div.notice", RE_POLITENESS)
end
Then %r{we should not even be polite about it} do
  page.should_not have_tag("div.error,div.notice", RE_POLITENESS)
end

#
# Resource's attributes
#
# "Then page should have the $resource's $attributes" is in resource_steps

# helpful debug step
Then "we dump the response" do
  dump_response
end


def have_flash notice, match
  have_selector("div.#{notice}") {|div| div.should contain(match)}
end

def have_no_flash notice, match
  if page.find("div.#{notice}")
    page.find("div.#{notice}").should_not contain(match)
  end
end

RE_PRETTY_RESOURCE = /the (index|show|new|create|edit|update|destroy) (\w+) (page|form)/i
RE_THE_FOO_PAGE    = /the '?([^']*)'? (page|form)/i
RE_QUOTED_PATH     = /^'([^']*)'$/i
def grok_path path
  path.gsub(/\s+again$/,'') # strip trailing ' again'
  case
  when path == 'the home page'    then dest = '/'
  when path =~ RE_PRETTY_RESOURCE then dest = template_for $1, $2
  when path =~ RE_THE_FOO_PAGE    then dest = $1
  when path =~ RE_QUOTED_PATH     then dest = $1
  else                                 dest = path
  end
  dest
end

# turns 'new', 'road bikes' into 'road_bikes/new'
# note that it's "action resource"
def template_for(action, resource)
  "#{resource.gsub(" ","_")}/#{action}"
end

