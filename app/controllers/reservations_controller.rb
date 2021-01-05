# frozen_string_literal: true

class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: %i[show cancel]

  def index
    @reservations = Reservation
                    .includes(seats: [:description])
                    .attending_or_hosting(current_user.id)
                    .order(created_at: :desc)
                    .page(params[:page])
  end

  def cancel
    ReservationCancelWorker.perform_async(@reservation.id)
    flash[:info] = t('order.cancel.success')
    redirect_to reservations_path
  end

  private

  def set_reservation
    @reservation = Reservation
                   .includes(seats: [:customer, { description: :invoice_item }])
                   .attending_or_hosting(current_user.id)
                   .find params[:id]
  end
end
