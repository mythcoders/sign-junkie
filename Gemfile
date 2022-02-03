# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.3"
gem "rails", "~> 7.0.0"

gem "cssbundling-rails"
gem "importmap-rails"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"

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
gem "image_processing"
gem "jbuilder"
gem "kaminari" # Pagination
gem "lograge" # Logging'
gem "paper_trail"
gem "pg"
gem "pinglish"
gem "puma"
gem "rack-cors"
gem "ransack" # Searching
gem "recaptcha" # Google recaptcha
gem "redcarpet" # Markdown rendering
gem "terser" # JS compressor
gem "view_component"

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
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "rspec_junit_formatter"
  gem "shoulda-matchers"
  gem "standard"
  gem "timecop"
end

group :development do
  gem "listen"
  gem "web-console", ">= 3.3.0"
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
