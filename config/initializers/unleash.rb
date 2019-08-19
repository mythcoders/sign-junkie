# frozen_string_literal: true

Unleash.configure do |config|
  config.url      = Rails.application.credentials.unleash_url
  config.instance_id = Rails.application.credentials.unleash_instance_id
  config.app_name = ENV['GITLAB_ENVIRONMENT_NAME'] || Rails.env
  config.logger   = Rails.logger
end

UNLEASH = Unleash::Client.new