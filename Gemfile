# Edit this Gemfile to bundle your application's dependencies.
# This preamble is the current preamble for Rails 3 apps; edit as needed.
source 'http://rubygems.org'

gem 'rails', '3.0.0.beta4'
gem 'mysql'
gem 'sqlite3-ruby'

gem 'compass', :require => 'compass'
gem 'ruby-units'
gem 'bluecloth'
gem 'ferret'
gem 'hoptoad_notifier'
gem 'rmagick', :require => 'rmagick'
gem 'mini_fb'

gem "haml", ">=3.0.0", :require => 'haml'
gem "compass", ">= 0.10.0"

group :development do
  gem 'ruby-debug'
  gem 'vlad'
  gem 'vlad-git'
end

group :test do
  gem "rspec-rails", ">= 2.0.0.beta.14.2"
  gem 'factory_girl_rails'
  gem 'webrat'
  gem 'capybara'
  # new cucumber doesn't like being run in it's own environment :(
  gem 'fakeweb', :git => "git://github.com/woahdae/fakeweb.git", :branch => "curb_support", :require => 'fakeweb'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
  gem 'ruby-debug'
end

group :cucumber do
  gem 'ruby-debug', :require => 'ruby-debug'
  gem "rspec-rails", ">= 2.0.0.beta.14.2"
  gem 'factory_girl_rails'
  gem 'webrat'
  gem 'fakeweb', :git => "git://github.com/woahdae/fakeweb.git", :branch => "curb_support", :require => 'fakeweb'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
end
