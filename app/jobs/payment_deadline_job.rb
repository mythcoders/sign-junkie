
# Voids an unpaid reservations 24-hours before the workshop
class PaymentDeadlineJob < ApplicationJob
  queue_as :default

  def perform(*guests)
    # Do something later
  end
end
