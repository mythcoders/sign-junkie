# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.configure do
  config.force_ssl = true

  config.cache_classes = true

  config.eager_load = true

  config.consider_all_requests_local = false

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.assets.js_compressor = :uglifier
  # config.assets.compile = true

  config.action_controller.perform_caching = true
  config.action_controller.asset_host = 'https://qa.signjunkieworkshop.com'
  config.action_mailer.perform_caching = false
  config.action_mailer.perform_deliveries = true
  config.action_mailer.asset_host = 'https://qa.signjunkieworkshop.com'
  config.action_mailer.default_url_options = {
    host: 'https://qa.signjunkieworkshop.com'
  }
  config.active_storage.service = :amazon
  config.active_support.deprecation = :notify

  config.i18n.fallbacks = true

  config.log_tags = [:request_id]
  config.log_formatter = ::Logger::Formatter.new
  logger_options = {
    app: 'sign-junkie',
    hostname: 'mcdig-qaapp-signjunkie',
    level: 'DEBUG',
    env: Rails.env
  }
  config.logger = Logdna::RailsLogger.new(Rails.application.credentials.logging_api, logger_options)

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false
end
# rubocop:enable Metrics/BlockLength
