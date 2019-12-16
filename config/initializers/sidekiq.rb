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
    mgr.register('15 0 * * *', CartCleanupWorker)
    mgr.register('30 0 * * *', PaymentDeadlineWorker)
    mgr.register('0 1 * * *', RegistrationDeadlineWorker)
    mgr.register('0 2 * * *', ReservationDepositRefundWorker)
    mgr.register('0 6 * * *', AbandonedCartReminderWorker)

    # mgr.register('0 6 * * *', PaymentDeadlineReminderWorker)
    # mgr.register('0 6 * * *', RegistrationDeadlineReminderWorker)
    # mgr.register('0 6 * * *', UnconfirmedAccountReminderWorker)
  end

  config.death_handlers << lambda { |job, ex|
    Raven.extra_context job_id: job['jid']
    Raven.extra_context job_class: job['class']
    Raven.capture_exception(ex)
  }
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end

Sidekiq::Client.reliable_push!
Sidekiq::Extensions.enable_delay!
