# frozen_string_literal: true

module Admin
  class ReservationsController < AdminController
    before_action :set_reservation, only: %i[cancel forfeit]

    def cancel
      ReservationCancelWorker.perform_async(@reservation.id)
      flash[:info] = t("order.cancel.success")
      redirect_to admin_workshop_path(@reservation.workshop_id)
    end

    def forfeit
      if @reservation.update(forfeit_params)
        flash[:success] = t("update.success")
      else
        flash[:error] = t("update.failure")
      end
      redirect_to admin_workshop_path(@reservation.workshop_id)
    end

    private

    def forfeit_params
      {forfeit_deposit: true}
    end

    def set_reservation
      @reservation = Reservation.find params[:id]
    end
  end
end
