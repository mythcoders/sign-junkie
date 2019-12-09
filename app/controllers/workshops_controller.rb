# frozen_string_literal: true

class WorkshopsController < ApplicationController
  before_action :set_workshop, only: %i[show project_info]
  before_action :set_seat_check, only: %i[show]
  before_action :set_reservation_check, only: %i[show]
  before_action :set_guest_purchase, only: %i[show]

  def public
    @workshops = Workshop.includes(:workshop_type)
                         .where(workshop_types: { name: 'Public' })
                         .for_sale
                         .order(:start_date)
  end

  def private
    @workshops = Workshop.includes(:workshop_type)
                         .where(workshop_types: { name: 'Private' })
                         .for_sale
                         .order(:start_date)
  end

  def project_info
    @project = Project.find(params[:project_id])
  end

  private

  def set_workshop
    @workshop = Workshop.find(params[:id])
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

  def set_guest_purchase
    if UNLEASH.is_enabled?("guest_purchase", @unleash_context)
      @guest_purchase = true
    else
      @guest_purchase = false
    end
  end
end
