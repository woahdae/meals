# Edit this Gemfile to bundle your application's dependencies.
# This preamble is the current preamble for Rails 3 apps; edit as needed.
source 'http://rubygems.org'

gem 'rails', '3.0.0'
gem 'mysql'
gem 'sqlite3-ruby'

gem 'ruby-units'
gem 'bluecloth'
gem 'ferret'
gem 'hoptoad_notifier'
gem 'rmagick', :require => 'RMagick'
gem 'mini_fb'
gem 'json' # needed by mini_fb

gem "haml", ">=3.0.18", :require => 'haml'
gem "compass", ">= 0.10.0"

group :development do
  gem 'ruby-debug'
  gem 'railroady'
  gem 'vlad'
  gem 'vlad-git', :require => 'vlad/git'
end

group :test do
  gem "rspec-rails", "2.0.1"
  gem 'factory_girl_rails'
  gem 'webrat'
  gem 'capybara'
  gem 'capybara-iphone',
      :git => 'git://github.com/rhburrows/capybara-iphone.git'
  # new cucumber doesn't like being run in it's own environment :(
  gem 'fakeweb'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
  gem 'ruby-debug'
end

