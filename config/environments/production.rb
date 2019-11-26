# frozen_string_literal: true

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  if ENV['CDN_URL']
    config.action_controller.asset_host = ENV['CDN_URL']
    config.action_mailer.asset_host = ENV['CDN_URL']
  else
    config.action_mailer.asset_host = "https://#{ENV['GITLAB_ENVIRONMENT_URL']}"
  end

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.assets.js_compressor = Uglifier.new(harmony: true)
  config.assets.css_compressor = :sass

  config.log_level = :info
  config.log_tags = [:request_id]

  config.active_storage.service = :amazon

  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = {
    host: ENV['GITLAB_ENVIRONMENT_URL']

  }
  config.action_mailer.smtp_settings = {
    user_name: Rails.application.credentials.dig(:email, :username),
    password: Rails.application.credentials.dig(:email, :password),
    domain: 'columbus.rr.com',
    address: 'email-smtp.us-east-1.amazonaws.com',
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true
  }
end
