# frozen_string_literal: true

require "sidekiq"
require "sidekiq-scheduler"

redis_config = {
  url: ENV["REDIS_URL"],
  namespace: "#{ENV["REDIS_NAMESPACE"]}-sidekiq",
  network_timeout: 3
}

# This is the recommendation from sidekiq-scheduler:
#   https://github.com/moove-it/sidekiq-scheduler#notes-about-connection-pooling
redis_pool_size = Sidekiq.options[:concurrency] + 5 + Rufus::Scheduler::MAX_WORK_THREADS

Sidekiq.configure_server do |config|
  config.log_formatter = Sidekiq::Logger::Formatters::JSON.new
  config.redis = ConnectionPool.new(size: redis_pool_size) { Redis.new(**redis_config) }

  # https://github.com/mperham/sidekiq/issues/4496#issuecomment-677838552
  config.death_handlers << ->(job, exception) do
    worker = job["wrapped"].safe_constantize
    worker&.sidekiq_retries_exhausted_block&.call(job, exception)
  end
end

Sidekiq.configure_client do |config|
  config.redis = ConnectionPool.new(size: redis_pool_size) { Redis.new(**redis_config) }
end

Sidekiq.default_worker_options = {retry: 3}
