# frozen_string_literal: true

module Admin
  class SeatsController < AdminController
    before_action :set_seat, only: %i[cancel remind]

    def cancel
      SeatCancelWorker.perform_async(@seat.id)
      flash[:info] = t("order.cancel.success")
      redirect_to admin_workshop_path(@seat.workshop_id)
    end

    def remind
      SeatMailer.with(seat_id: @seat.id).remind.deliver_later
      flash[:success] = "Reminder sent"
      redirect_to admin_workshop_path(@seat.workshop_id)
    end

    private

    def set_seat
      @seat = Seat.find params[:id]
    end
  end
end
