namespace :query_trace do
  desc "Enables the query_trace plugin. Must restart server to take effect."
  task :on => :environment do
    unless File.exist?("#{Rails.root}/vendor/query_trace.tar.gz")
      Dir.chdir("#{Rails.root}/vendor") do
        url = "https://terralien.devguard.com/svn/projects/plugins/query_trace"
        puts "Loading query_trace from #{url}..."
        system "svn co #{url} query_trace"
        system "tar zcf query_trace.tar.gz --exclude=.svn query_trace"
        FileUtils.rm_rf("query_trace")
      end
    end
    Dir.chdir("#{Rails.root}/vendor/plugins") do
      system "tar -zxf ../query_trace.tar.gz query_trace"
    end
    puts "QueryTrace plugin enabled. Must restart server to take effect."
  end

  desc "Disables the query_trace plugin. Must restart server to take effect."
  task :off => :environment do
    FileUtils.rm_rf("#{Rails.root}/vendor/plugins/query_trace")
    puts "QueryTrace plugin disabled. Must restart server to take effect."
  end
end
