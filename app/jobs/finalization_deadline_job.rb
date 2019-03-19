
# Sends an invoice to the host of a reservation 72 hours before the workshop
class FinalizationDeadlineJob < ApplicationJob
  queue_as :default

  def perform(*guests)
    # Do something later
  end
end
