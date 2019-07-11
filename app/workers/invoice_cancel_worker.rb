# frozen_string_literal: true

class InvoiceCancelWorker
  include Sidekiq::Worker

  def perform(*args)
    # Do something
  end
end
