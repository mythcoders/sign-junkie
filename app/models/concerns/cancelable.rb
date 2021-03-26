# frozen_string_literal: true

module Cancelable
  extend ActiveSupport::Concern

  def cancelable?(is_admin = false)
    return false if refunded? ||
                    canceled? ||
                    voided? ||
                    workshop.start_date.past? ||
                    !is_admin && reservation_seat? && !workshop.reservation_allow_guest_cancel_seat?

    true
  end

  def canceled?
    cancel_date.present?
  end
end
