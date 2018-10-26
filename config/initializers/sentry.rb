# frozen_string_literal: true

Raven.configure do |config|
  config.dsn = Rails.application.credentials.errors_api
  config.environments = %w[test production]
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.processors -= [Raven::Processor::PostData] # Do this to send POST data
end
