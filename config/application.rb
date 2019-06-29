# frozen_string_literal: true

require_relative 'boot'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'
require 'pinglish'

Bundler.require(*Rails.groups)

module Ares
  class Application < Rails::Application
    config.load_defaults 5.2 # Initialize generated Rails version

    config.encoding = 'utf-8'
    config.time_zone = 'Eastern Time (US & Canada)'
    config.public_file_server.enabled
    config.eager_load_paths += %W[#{config.root}/lib]
    config.eager_load_paths += %W[#{config.root}/app/services]
    config.require_master_key = true
    config.force_ssl = true if Rails.env.qa? || Rails.env.production?

    config.skylight.probes += %w(active_model_serializers)
    config.skylight.environments += ['qa']

    # Storage
    config.active_storage.service = :amazon
    config.active_storage.variant_processor = :mini_magick

    # Email
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_caching = false
    ActionMailer::Base.smtp_settings = {
      user_name: 'apikey',
      password: Rails.application.credentials.email_api,
      domain: 'mythcoders.com',
      address: 'smtp.sendgrid.net',
      port: 587,
      authentication: :plain,
      enable_starttls_auto: true
    }
  end
end
