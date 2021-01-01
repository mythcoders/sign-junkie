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
    config.action_mailer.asset_host = Apollo.env_url
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

  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false
  config.action_mailer.default_url_options = {
    host: Apollo.env_url(protocol: false),
    protocol: 'https://'
  }
end
