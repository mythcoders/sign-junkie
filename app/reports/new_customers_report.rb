# frozen_string_literal: true

class NewCustomersReport
  def self.execute(start_date, end_date = Time.zone.now)
    User.customers
        .where('created_at BETWEEN :start_date AND :end_date', start_date: start_date,
                                                               end_date: end_date)
  end
end
