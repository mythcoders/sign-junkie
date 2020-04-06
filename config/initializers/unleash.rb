# frozen_string_literal: true

return if ENV['ASSETS_PRECOMPILE'].present?

Unleash.configure do |config|
  config.url = Rails.application.credentials.dig(:unleash, :api_url)
  config.instance_id = Rails.application.credentials.dig(:unleash, :instance_id)
  config.app_name = ENV['GITLAB_ENVIRONMENT_NAME'] || Rails.env
  # config.logger   = Rails.logger
end

UNLEASH = Unleash::Client.new
