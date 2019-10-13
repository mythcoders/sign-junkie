# frozen_string_literal: true

module Cancelable
  extend ActiveSupport::Concern

  def cancelable?
    return false if refunded? ||
                    canceled? ||
                    voided? ||
                    Time.zone.now > workshop.start_date ||
                    reservation_seat? && !workshop.reservation_allow_guest_cancel_seat

    true
  end

  def canceled?
    cancel_date.present?
  end
end
