# frozen_string_literal: true

require 'sidekiq/pro/web'
require 'sidekiq-status'

redis_config = {
  url: ENV['REDIS_URL'],
  namespace: ENV['REDIS_NAMESPACE'],
  network_timeout: 3
}

Sidekiq.default_worker_options = { retry: 3 }

Sidekiq.configure_server do |config|
  Sidekiq::Status.configure_server_middleware config

  config.redis = redis_config
  config.reliable_scheduler!
  config.super_fetch!
end

Sidekiq.configure_client do |config|
  Sidekiq::Status.configure_client_middleware config

  config.redis = redis_config
end

Sidekiq::Client.reliable_push!