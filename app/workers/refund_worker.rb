# frozen_string_literal: true

class RefundWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(item_description_id)
    Rails.logger.debug "RefundWorker - #{item_description_id}"
    RefundService.new.refund_item(item_description_id)
  end
end
