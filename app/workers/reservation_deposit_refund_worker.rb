# frozen_string_literal: true

class ReservationDepositRefundWorker
  include Sidekiq::Worker

  def perform
    reservations.each do |reservation|
      break unless reservation.refundable?

      Rails.logger.info "Refunded deposit for reservation #{reservation.id}"
      RefundService.new.refund_item(reservation.item_description_id)
    end
  end

  def reservations
    Reservation.includes(:workshop).where(workshops: { start_date: two_days_ago.all_day })
  end

  def two_days_ago
    Time.zone.now - 2.days
  end
end
