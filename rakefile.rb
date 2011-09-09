namespace :db do
  desc "Create database"
  task :migrate do
    exec 'sequel -m db/migrations/. sqlite://' + File.dirname(__FILE__) + '/db/rackspace-cloud-s3.db'
  end

  desc "Delete Database File"
  task :delete do
    FileUtils.rm_rf(File.dirname(__FILE__) + "/db/ganymede.db")
  end
end 
