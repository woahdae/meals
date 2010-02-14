require 'rubygems'
require 'spork'
 
Spork.prefork do
  ENV["RAILS_ENV"] ||= "cucumber"
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
 
  FakeWeb.allow_net_connect = false
  
  require 'cucumber'
  require 'cucumber/formatter/unicode'
  require 'cucumber/rails/rspec'
  require 'spec/rails'
  require 'webrat'
  require 'webrat/core/matchers'
  require 'cucumber/rails/world'
 
  require 'facebooker/rails/cucumber'
  Facebooker::Rails::IntegrationSession.canvas = false

  Cucumber::Rails::World.use_transactional_fixtures = true

  Webrat.configure do |config|
    config.mode = :rails
  end
end
 
Spork.each_run do
  DatabaseCleaner.clean_with(:truncation)
end

Before do
  ActiveRecord::Base.connection.increment_open_transactions
  ActiveRecord::Base.connection.begin_db_transaction
end

After do
  ActiveRecord::Base.connection.rollback_db_transaction
end