# frozen_string_literal: true

module Refundable
  extend ActiveSupport::Concern

  def refundable?
    return false if refunded? || gift_card?
    return true if workshop.cancel_date.present?
    return false if seat? && Time.zone.now >= workshop.start_date
    return false if reservation? && (reservation.forfeit_deposit ||
                                     (Time.zone.now >= workshop.end_date && !reservation.requirements_met?))

    true
  end

  def refunded?
    refund_date.present?
  end

  def amount_refundable
    return 0.00 unless refundable?

    if seat?
      time_until_workshop = workshop.start_date - Time.zone.now
      if time_until_workshop >= 48.hours
        line_total
      elsif time_until_workshop < 48.hours && time_until_workshop > 24.hours
        (line_total / 2).round(2)
      else
        0.00
      end
    elsif reservation?
      line_total
    else
      0.00
    end
  end
end
