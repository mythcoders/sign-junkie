# frozen_string_literal: true

class WorkshopsController < ApplicationController
  before_action :set_workshop, only: %i[show seat reservation project_info]
  before_action :set_seat_check, only: %i[show seat]
  before_action :set_reservation_check, only: %i[show reservation]

  def public
    @workshops = Workshop
                 .includes(:workshop_type)
                 .where(workshop_types: { name: 'Public' })
                 .for_sale
                 .order(:start_date)
  end

  def seat
    # redirect somewhere if no seat purchase
  end

  def seat
    # redirect somewhere if no reservation purchase
  end

  def private
    @workshops = Workshop
                 .includes(:workshop_type)
                 .where(workshop_types: { name: 'Private' })
                 .for_sale
                 .order(:start_date)
  end

  def project_info
    @project = Project.find params[:project_id]
  end

  private

  def set_workshop
    @workshop = Workshop.find params[:id]
  end

  def set_seat_check
    @already_attending = if current_user
                           seats = Seat.active.for_shop(@workshop.id).for_user(current_user)
                           seats.any? ? seats.first.id : false
                         else
                           false
                         end
  end

  def set_reservation_check
    @already_hosting = if current_user
                         reservations = Reservation.active.for_shop(@workshop.id).for_user(current_user)
                         reservations.any? ? reservations.first.id : false
                       else
                         false
                       end
  end
end
