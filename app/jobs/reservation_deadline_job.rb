# 10 days before a workshop, any unpaid seats are voided
class ReservationDeadlineJob < ApplicationJob
  queue_as :default

  def perform(*guests)
    # Do something later
  end
end
