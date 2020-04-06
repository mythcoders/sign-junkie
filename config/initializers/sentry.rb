# frozen_string_literal: true

return if ENV['ASSETS_PRECOMPILE'].present?

Raven.configure do |config|
  config.dsn = Rails.application.credentials.dig(:sentry, :api)
  config.environments = %w[review staging production]
  config.silence_ready = true
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.processors -= [Raven::Processor::PostData] # Do this to send POST data
end
