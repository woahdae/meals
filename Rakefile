# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Rails::Application.load_tasks

begin
  require 'vlad'
  Vlad.load :scm => :git
rescue LoadError
  # do nothing
end

task :default => [:cucumber]
