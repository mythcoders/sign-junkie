# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'audited' # data audits
gem 'aws-sdk-s3', require: false
gem 'bootsnap', '>= 1.1.0', require: false
gem 'braintree'
gem 'devise'
gem 'image_processing', '~> 1.2'
gem 'jbuilder'
gem 'kaminari' # Pagination
gem 'logdna-rails' # Logging
gem 'pg'
gem 'pinglish'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.0'
gem 'sendgrid-ruby' # ActiveMailer
gem 'sentry-raven' # Exceptions

# UI
gem 'bootstrap'
gem 'bootstrap4-datetime-picker-rails'
gem 'haml'
gem 'haml-rails'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'redcarpet' # Markdown rendering
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
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
