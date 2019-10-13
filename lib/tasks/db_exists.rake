# frozen_string_literal: true

namespace :db do
  desc 'Checks to see if the database exists'
  task :exists do
    Rake::Task['environment'].invoke
    ActiveRecord::Base.connection
  rescue StandardError
    puts 'Does not exist'
    exit 1
  else
    puts 'Already exists'
    exit 0
  end
end
