# frozen_string_literal: true

class SeatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: %i[new create]
  before_action :set_seat, only: %i[show edit update cancel remind]
  before_action :authorize_add, only: %i[new create]
  before_action :authorize_edit, only: %i[edit update]

  def index
    @seats = Seat.for_user(current_user).order(created_at: :desc).page(params[:page])
  end

  def create
    if SeatService.new.add(guest_params.merge(reservation: @reservation))
      flash[:success] = t('success.create')
      redirect_to reservation_path(@reservation)
    else
      flash[:error] = t('failure.create')
      render 'new'
    end
  end

  def update
    if SeatService.new.update(@seat, seat_params)
      flash[:success] = t('success.update')
      redirect_to seat_path(@seat)
    else
      flash[:error] = t('failure.update')
      render 'edit'
    end
  end

  def remind
    SeatMailer.with(seat: @seat).remind.deliver_now
    flash[:success] = 'Reminder sent'
    redirect_to reservation_path(@seat.reservation.id)
  end

  def cancel
    SeatCancelWorker.perform_async(@seat.id)
    flash[:info] = t('seat.cancel.success')
    redirect_to @seat.reservation.present? ? reservation_path(@seat.reservation.id) : seat_path(@seat)
  end

  private

  def seat_params
    params.require(:cart).permit(:id, :project_id, :addon_id, :stencil_id, :stencil, :seating,
                                 :design_confirmation, :policy_agreement, :acknowledgment)
  end

  def guest_params
    params.require(:seat).permit(:first_name, :last_name, :email)
  end

  def set_seat
    @seat = Seat.find params[:id]
  end

  def set_reservation
    @reservation = Reservation.find(params[:reservation_id])
  end

  def authorize_add
    unless @reservation.may_add_seat?(current_user)
      flash[:error] = t('reservations.no_more_seats')
      redirect_to reservation_path(@reservation)
    end
  end

  def authorize_edit
    unless @seat.editable?(current_user)
      flash[:error] = t('seat.not_editable')
      redirect_to reservation_path(@reservation)
    end
  end
end