task :environment => "usda_ndb:config" do
  module Rails
    def self.env
      ENV['RAILS_ENV']
    end
    def self.root
      File.expand_path(File.dirname(__FILE__) + "/../")
    end
  end
  
  RAILS_ROOT = Rails.root
  
  ActiveRecord::Base.establish_connection(@config[Rails.env])
end

task "db:data:load" => ["usda_ndb:unzip_data", "db:schema:load"]

namespace :usda_ndb do
  
  task :unzip_data do
    base = File.join(File.dirname(__FILE__), "..", "db")
    
    if !File.exist?(File.join(base, "data.yml"))
      require 'zlib'
      File.open(File.join(base, "data.yml"), "w") do |file| 
        file << Zlib::Inflate.inflate(File.read(File.join(base, "data.yml.gz")))
      end
    end
  end
  
  task :check_config do
    if !File.exist?("config/usda_ndb.yml")
      File.open("config/usda_ndb.yml", "w") do |file|
        file << File.read(File.dirname(__FILE__) + "/../config/usda_ndb.yml")
        EOF
      end
    end
  end
  
  task :config => :check_config do
    @config = YAML.load(File.read("config/usda_ndb.yml"))
  end

  namespace :sql do
    
    desc "create db/usda_ndb_seed.sql from db/usda_ndb_orig.sql"
    task :translate_original => :config do
      require File.join(File.dirname(__FILE__), 'db/usda_translate.rb')
    end

    desc "load the dumped seed data from db/development_seed.sql into the current env's database (mysql only)"
    task :mysql_load => :config do
      system("mysql --user=#{@config['username']} --password=#{@config['password']} #{@config['database']} < db/usda_ndb_seed.sql")
     end
  end
end
