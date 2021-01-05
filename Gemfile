# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'aasm'
gem 'aws-sdk-s3'
gem 'bootsnap', require: false
gem 'braintree'
gem 'deep_cloneable'
gem 'devise'
gem 'devise_invitable'
gem 'elastic-apm'
gem 'faker'
gem 'haml-rails'
gem 'hotwire-rails'
gem 'image_processing'
gem 'jbuilder'
gem 'kaminari' # Pagination
gem 'lograge' # Logging'
gem 'paper_trail'
gem 'pg'
gem 'pinglish'
gem 'premailer-rails'
gem 'puma'
gem 'rails', '~> 6.0.0'
gem 'ransack' # Searching
gem 'redcarpet' # Markdown rendering
gem 'sassc-rails'
gem 'uglifier'
gem 'view_component', require: "view_component/engine"
gem 'webpacker'
gem 'websocket-extensions', '>= 0.1.5'

# sentry exceptions
gem 'sentry-ruby'
gem 'sentry-rails'
gem 'sentry-sidekiq'

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
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'guard-rspec'
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'

  # development experience and debugging
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'debase'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'ruby-debug-ide'
end

group :test do
   gem 'selenium-webdriver'
   gem 'webdrivers', '~> 4.0', require: false
 end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
