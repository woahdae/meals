set :application,     "meals"
set :domain,          "slicehost"
set :deploy_to,       "/home/woody/www/meals"
set :repository,      'git@github.com:woahdae/meals.git'
# set :revision,        "origin/facebook"
set :keep_releases,   5

namespace :vlad do
  remote_task :symlink do
    # Link to shared resources, if you have them in .gitignore
    run "ln -s #{deploy_to}/shared/system/database.yml #{deploy_to}/current/config/database.yml"
    run "ln -s #{deploy_to}/shared/system/usda_ndb.yml #{deploy_to}/current/config/usda_ndb.yml"
    run "ln -s #{deploy_to}/shared/indexes #{deploy_to}/current/tmp/indexes"
    run "ln -s #{deploy_to}/shared/photos #{deploy_to}/current/public/photos"
  end
  
  remote_task :touch do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end
  
  remote_task :deploy => [:update, :cleanup, :symlink, :touch]
  remote_task :deploy_with_migrations => [:update, :cleanup, :symlink, :migrate, :touch]
end
