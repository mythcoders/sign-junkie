# frozen_string_literal: true

module Admin
  class WorkshopTypesController < AdminController
    before_action :set_workshop_type, only: %i[show edit update]

    def index
      @types = WorkshopType.all.page(params[:page])
    end

    def new
      @workshop_type = WorkshopType.new
    end

    def create
      @workshop_type = WorkshopType.new(workshop_type_params)

      if @workshop_type.save
        flash[:success] = t('create.success')
        redirect_to admin_workshop_types_path
      else
        render 'new', status: :unprocessable_entity
      end
    end

    def update
      if @workshop_type.update(workshop_type_params)
        flash[:success] = t('update.success')
        redirect_to admin_workshop_types_path
      else
        render 'edit', status: :unprocessable_entity
      end
    end

    private

    def set_workshop_type
      @workshop_type = WorkshopType.find params[:id]
    end

    def workshop_type_params
      params.require(:workshop_type).permit(:name, :default_reservation_allow, :default_reservation_allow_multiple,
                                            :default_total_seats, :default_reservation_price,
                                            :default_reservation_minimum, :default_reservation_maximum,
                                            :default_reservation_cancel_minimum_not_met, :default_single_seat_allow,
                                            :default_reservation_allow_guest_cancel_seat)
    end
  end
end
