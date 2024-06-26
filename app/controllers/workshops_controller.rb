# frozen_string_literal: true

class WorkshopsController < ApplicationController
  before_action :set_workshop, only: %i[show seat reservation projects]
  before_action :authenticate_user!, only: %i[seat reservation]
  before_action :set_seat_check, only: %i[show seat]
  before_action :set_reservation_check, only: %i[show reservation]

  def public
    @workshops = Workshop
      .includes(:workshop_type)
      .where(workshop_types: {name: "Public"})
      .for_sale
      .order(:start_date)
  end

  def private
    @workshops = Workshop
      .includes(:workshop_type)
      .where(workshop_types: {name: "Private"})
      .for_sale
      .order(:start_date)
  end

  def seat
    # TODO: redirect somewhere if no seat purchase
    @seat = OpenStruct.new(workshop: @workshop, selection_made?: false, persisted?: false, guest_type: nil)
  end

  def reservation
    # TODO: redirect somewhere if no reservation purchase
  end

  def projects
    @projects = if params[:include_children]
      @workshop.projects.active
    else
      @workshop.projects.where(only_for_children: false).active
    end
    render layout: false
  end

  private

  def set_workshop
    @workshop = Workshop.find params[:id]
  end

  def set_seat_check
    @existing_seat_id = if current_user
      seats = Seat.active.for_shop(@workshop.id).for_user(current_user)
      seats.any? ? seats.first.id : 0
    else
      0
    end
  end

  def set_reservation_check
    @existing_reservation_id = if current_user
      reservations = Reservation.active.for_shop(@workshop.id).for_user(current_user)
      reservations.any? ? reservations.first.id : 0
    else
      0
    end
  end
end
