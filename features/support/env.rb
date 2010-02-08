require 'rubygems'
require 'spork'
 
Spork.prefork do
  # Sets up the Rails environment for Cucumber
  ENV["RAILS_ENV"] ||= "cucumber"
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
 
  FakeWeb.allow_net_connect = false

  
  require 'webrat'
 
  Webrat.configure do |config|
    config.mode = :rails
  end
 
  require 'webrat/core/matchers'
  require 'cucumber'

  # Comment out the next line if you don't want Cucumber Unicode support
  require 'cucumber/formatter/unicode'

  require 'spec/rails'
  require 'cucumber/rails/rspec'

  Cucumber::Rails::World.use_transactional_fixtures
end
 
Spork.each_run do
  # This code will be run each time you run your specs.
  require 'cucumber/rails/world'
  require 'facebooker/rails/cucumber'
  Facebooker::Rails::IntegrationSession.canvas = false
end