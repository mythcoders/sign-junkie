# frozen_string_literal: true

class RegistrationDeadlineReminderWorker
  include Sidekiq::Worker

  def perform; end

  def reservations(as_of = Time.zone.today)
    Reservation.active
               .joins(:workshop)
               .where("date_trunc('day', workshops.start_date - interval '7 days') = date_trunc('day', ?::date)", as_of)
  end
end
