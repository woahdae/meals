require 'rubygems'
require 'spork'
 
Spork.prefork do
  # Sets up the Rails environment for Cucumber
  ENV["RAILS_ENV"] ||= "cucumber"
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
 
  require 'ruby-debug'

  FakeWeb.allow_net_connect = true
  
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
  
  # should do this automatically, but it's not
  require 'features/support/facebook_connect_stubs'
end
 
Spork.each_run do
end