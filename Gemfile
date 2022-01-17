# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.5"

gem "aasm"
gem "aws-sdk-s3"
gem "bootsnap", require: false
gem "bootstrap-email"
gem "braintree"
gem "deep_cloneable"
gem "devise"
gem "devise_invitable"
gem "faker"
gem "haml-rails"
gem "hotwire-rails"
gem "image_processing"
gem "jbuilder"
gem "kaminari" # Pagination
gem "lograge" # Logging'
gem "paper_trail"
gem "pg"
gem "pinglish"
gem "puma"
gem "rack-cors"
gem "rails", "~> 6.1.0"
gem "ransack" # Searching
gem "recaptcha" # Google recaptcha
gem "redcarpet" # Markdown rendering
gem "sassc-rails"
gem "uglifier"
gem "view_component", require: "view_component/engine"
gem "webpacker"
gem "websocket-extensions", ">= 0.1.5"

# sentry exceptions
gem "sentry-rails"
gem "sentry-ruby", ">= 4.2.0"
gem "sentry-sidekiq", ">= 4.2.0"

# sidekiq
gem "redis-namespace"
gem "sidekiq"
gem "sidekiq-scheduler"

source "https://rubygems.pkg.github.com/mythcoders" do
  gem "hermes"
end

group :development, :test do
  gem "bundler-audit"
  gem "capybara"
  gem "factory_bot_rails"
  gem "guard-rspec"
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "rspec_junit_formatter"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "standard"
  gem "timecop"

  # development experience and debugging
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "debase"
  gem "pry-byebug"
  gem "pry-rails"
  gem "ruby-debug-ide"
end

group :test do
  gem "selenium-webdriver"
  gem "webdrivers", "~> 4.0", require: false
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
