# frozen_string_literal: true

require 'sidekiq/pro/web'

redis_config = {
  url: ENV['REDIS_URL'],
  namespace: ENV['WORKER_REDIS_NAMESPACE'],
  network_timeout: 3
}

Sidekiq.default_worker_options = { retry: 3 }

Sidekiq.configure_server do |config|
  config.redis = redis_config
  config.reliable_scheduler!
  config.super_fetch!

  config.periodic do |mgr|
    mgr.register('0 4 * * *', ReservationDepositRefundWorker)
    mgr.register('15 4 * * *', RegistrationDeadlineWorker)
    mgr.register('35 4 * * *', PaymentDeadlineWorker)
    mgr.register('0 5 * * *', CartCleanupWorker)
    mgr.register('0 6 * * *', AbandonedCartReminderWorker)
    mgr.register('0 6 * * *', PaymentDeadlineReminderWorker)
    mgr.register('0 6 * * *', RegistrationDeadlineReminderWorker)
    mgr.register('0 6 * * *', UnconfirmedAccountReminderWorker)
  end

  # Touch a file so we know Sidekiq worker has started.
  # Used for health checks
  config.on(:startup) do
    FileUtils.touch(Rails.root.join('tmp', 'pids', 'sidekiq_started'))
  end

  # Delete the touched file so we know Sidekiq worker has stopped.
  # Used for health checks
  config.on(:shutdown) do
    FileUtils.rm(Rails.root.join('tmp', 'pids', 'sidekiq_started'))
  end
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end

# Sidekiq::Client.reliable_push!
# Sidekiq::Extensions.enable_delay!
