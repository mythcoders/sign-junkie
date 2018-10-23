# frozen_string_literal: true

ruby '2.5.1'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'audited' # data audits
gem 'aws-sdk-s3', require: false
gem 'bootsnap', '>= 1.1.0', require: false
gem 'braintree'
gem 'devise'
gem 'jbuilder', '~> 2.5'
gem 'kaminari' # Pagination
gem 'logdna-rails' # Logging
gem 'lograge'
gem 'mini_magick'
gem 'pg'
gem 'pinglish'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.0'
gem 'sendgrid-ruby' # ActiveMailer

# UI
gem 'bootstrap'
gem 'bootstrap4-datetime-picker-rails'
gem 'coffee-rails'
gem 'haml'
gem 'haml-rails'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'redcarpet' # Markdown rendering
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara'
  gem 'debase'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'guard-rspec'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '3.7.2'
  gem 'ruby-debug-ide'
  gem 'shoulda-matchers'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'chromedriver-helper'
  gem 'selenium-webdriver'
  gem 'timecop'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
