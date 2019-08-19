namespace :db do
  desc "Checks to see if the database exists"
  task :exists do
    begin
      Rake::Task['environment'].invoke
      ActiveRecord::Base.connection
    rescue
      puts 'DB not found'
      exit 1
    else
      puts 'DB found'
      exit 0
    end
  end
end