# frozen_string_literal: true

module Refundable
  extend ActiveSupport::Concern

  def refundable?
    return false if gift_card?
    return false if workshop.start_date <= DateTime.now
    return false if cancel_date.present? || void_date.present?

    true
  end

  def amount_refundable
    return 0.00 unless refundable?

    time_until_workshop = workshop.start_date - DateTime.now
    if time_until_workshop >= 48.hours
      line_total
    elsif time_until_workshop < 48.hours && time_until_workshop > 24.hours
      (line_total / 2).round(2)
    else
      0.00
    end
  end
end
