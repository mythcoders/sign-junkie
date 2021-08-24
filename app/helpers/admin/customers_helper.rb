# frozen_string_literal: true

module Admin
  module CustomersHelper
    def status_badge_class(customer)
      case customer.status[:title]
      when :confirmed
        "badge-success"
      when :locked
        "badge-danger"
      when :pending
        "badge-info"
      when :invited
        "badge-info"
      end
    end

    def status_date_title(customer)
      case customer.status[:title]
      when :confirmed
        "Confirmation Date"
      when :locked
        "Locked Date"
      when :pending
        "Confirmation Send Date"
      when :invited
        "Invited Date"
      end
    end

    def allow_resent_confirmation_email?(customer)
      %i[pending invited].include? customer.status[:title]
    end
  end
end
