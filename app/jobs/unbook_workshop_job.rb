class UnbookWorkshopJob < ApplicationJob
  queue_as :default

  def perform(*guests)
    # Do something later
  end
end
