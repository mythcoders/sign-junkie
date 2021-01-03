# frozen_string_literal: true

return if ENV['ASSETS_PRECOMPILE'].present?

Sentry.init do |config|
  config.dsn = Rails.application.credentials.dig(:sentry, :private_dsn)
  config.breadcrumbs_logger = [:active_support_logger]
  config.enabled_environments = %w[review staging production]
end
