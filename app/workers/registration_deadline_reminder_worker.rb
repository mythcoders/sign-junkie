# frozen_string_literal: true

class RegistrationDeadlineReminderWorker
  include Sidekiq::Worker

  def perform
    reservations.each do |reservation|
      reservation.active_seats.each do |seat|
        next if seaat.selection_made?

        SeatMailer.with(seat_id: seat.id).registration_deadline.deliver_later
      end
    end
  end

  private

  def reservations(as_of = Time.zone.today)
    Reservation.active
               .joins(:workshop)
               .where("date_trunc('day', workshops.start_date - interval '7 days') = date_trunc('day', ?::date)", as_of)
  end
end
