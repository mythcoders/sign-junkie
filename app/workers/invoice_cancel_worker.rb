# frozen_string_literal: true

class InvoiceCancelWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(_args)
    # Do something
    Rails.logger.info 'Completed!'
  end
end
