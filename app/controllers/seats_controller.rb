# frozen_string_literal: true

class SeatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: %i[new edit create update]
  before_action :set_seat, only: %i[show edit update cancel remind]
  before_action :authorize_seat, only: %i[show edit update cancel remind]
  before_action :authorize_add, only: %i[new create]
  before_action :authorize_edit, only: %i[edit update]
  before_action :set_seat_check, only: %i[new]

  # /seats
  def index
    @seats = Seat.for_user(current_user)
  end

  # /seats/:id
  # def show

  # /reservation/:reservation_id/seats
  def new
    @seat = Seat.new reservation: @reservation, workshop: @reservation.workshop, description: ItemDescription.new
  end

  # /reservation/:reservation_id/seats
  # rubocop:disable Metrics/AbcSize
  def create
    @seat = Seat.new(reservation: @reservation, workshop: @reservation.workshop)

    if SeatService::Updater.perform(@seat, current_user, seat_params)
      flash[:success] = t('create.success')

      if add_seat_to_cart?
        Cart.create! user: current_user, item_description_id: @seat.item_description_id
        redirect_to cart_index_path
      else
        redirect_to reservation_path(@reservation)
      end
    else
      flash[:error] = t('seat.create.failure')
      set_seat_check
      render 'new', status: :unprocessable_entity
    end
  end

  # /reservation/:reservation_id/seats/:seat_id
  def update
    if SeatService::Updater.perform(@seat, current_user, seat_params)
      flash[:success] = t('update.success')

      if add_seat_to_cart?
        Cart.create! user: current_user, item_description_id: @seat.item_description_id
        redirect_to cart_index_path
      else
        redirect_to seat_path @seat
      end
    else
      flash[:error] = t('update.failure')
      render 'edit', status: :unprocessable_entity
    end
  end
  # rubocop:enable Metrics/AbcSize

  # /reservation/:reservation_id/seats/:id/remind
  def remind
    SeatMailer.with(seat_id: @seat.id).remind.deliver_later
    flash[:success] = 'Reminder sent'
    redirect_to reservation_path(@seat.reservation.id)
  end

  # /seats/:id/cancel
  def cancel
    SeatCancelWorker.perform_async(@seat.id)
    flash[:info] = t('seat.cancel.success')
    redirect_to @seat.reservation.present? ? reservation_path(@seat.reservation.id) : seat_path(@seat)
  end

  private

  def seat_params
    params.require(:cart).permit CartFactory.permitted_params
  end

  def set_seat
    @seat = Seat.includes({ reservation: %i[description] }, :description).find params[:id]
  end

  def set_reservation
    @reservation = Reservation.includes(:workshop).find params[:reservation_id]
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

  def authorize_seat
    if @seat.user_id == current_user.id || (@seat.reservation && @seat.reservation.user_id == current_user.id)
      true
    else
      flash[:error] = t('seat.not_editable')
      redirect_back(fallback_location: seats_path)
    end
  end

  def set_seat_check
    @existing_seat_id = if current_user
                          seats = Seat.active.for_shop(@reservation.workshop_id).for_user(current_user)
                          seats.any? ? seats.first.id : 0
                        else
                          0
                        end
  end

  def add_seat_to_cart?
    @seat.selection_made? && !@seat.in_cart? && !@reservation.paid_by_host?
  end
end
