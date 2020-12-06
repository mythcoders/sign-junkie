# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'aasm'
gem 'aws-sdk-s3', require: false
gem 'bootsnap', require: false
gem 'braintree'
gem 'deep_cloneable'
gem 'devise'
gem 'devise_invitable', '~> 2.0'
gem 'elastic-apm'
gem 'faker'
gem 'haml'
gem 'haml-rails'
gem 'image_processing', '~> 1.2'
gem 'jbuilder'
gem 'kaminari', '>= 1.2.1' # Pagination
gem 'lograge' # Logging'
gem 'lograge-sql'
gem 'paper_trail'
gem 'pg'
gem 'pinglish'
gem 'puma', '~> 4.3'
gem 'premailer-rails'
gem 'rails', '~> 6.0'
gem 'ransack' # Searching
gem 'redcarpet' # Markdown rendering
gem 'sass-rails', '~> 5.0'
gem 'sentry-raven' # Exceptions
gem 'uglifier', '>= 1.3.0'
gem 'view_component'
gem 'webpacker'
gem 'websocket-extensions', '>= 0.1.5'

# sidekiq
gem 'redis-namespace'
gem 'sidekiq', '~> 5.2'
gem 'sidekiq-ent', '~> 1.8.1'
gem 'sidekiq-status'

source 'https://rubygems.pkg.github.com/mythcoders' do
  gem 'hermes'
end

group :development, :test do
  gem 'bundler-audit'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara'
  gem 'debase'
  gem 'factory_bot_rails'
  gem 'guard-rspec'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'rspec_junit_formatter'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
  gem 'ruby-debug-ide'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
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
