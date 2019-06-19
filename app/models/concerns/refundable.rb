module Refundable
  extend ActiveSupport::Concern

  def refundable?
    return false if self.gift_card?
    return false if self.workshop.start_date <= DateTime.now
    return false if self.cancel_date.present? || self.void_date.present?

    true
  end

  def amount_refundable
    return 0.00 unless refundable?

    time_until_workshop = self.workshop.start_date - DateTime.now
    if time_until_workshop >= 48.hours
      self.line_total
    elsif time_until_workshop < 48.hours && time_until_workshop > 24.hours
      (self.line_total / 2).round(2)
    else
      0.00
    end
  end
end
