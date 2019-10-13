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
        flash[:success] = t('CreateSuccess')
        redirect_to admin_workshop_types_path
      else
        render 'new'
      end
    end

    def update
      if @workshop_type.update(workshop_type_params)
        flash[:success] = t('UpdateSuccess')
        redirect_to admin_workshop_types_path
      else
        render 'edit'
      end
    end

    private

    def set_workshop_type
      @workshop_type = WorkshopType.find params[:id]
    end

    def workshop_type_params
      params.require(:workshop_type).permit(:id, :name, :default_reservation_allow, :default_reservation_allow_multiple,
                                            :default_total_seats, :default_reservation_price,
                                            :default_reservation_minimum, :default_reservation_maximum,
                                            :default_single_seat_allow, :default_reservation_allow_guest_cancel_seat)
    end
  end
end
