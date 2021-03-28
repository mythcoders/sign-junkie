# frozen_string_literal: true

module Admin
  class WorkshopsController < AdminController
    before_action :populate_workshop, only: %i[edit update show destroy new_image upload_images clone]
    before_action :set_workshop_types, only: %i[edit update new]

    def index
      @q = case params[:scope]
           when 'all'
             Workshop.all
           when 'past'
             Workshop.where('start_date <= current_timestamp')
           else
             Workshop.where('start_date >= current_timestamp')
           end.ransack(params[:q])

      @q.sorts = 'start_date desc' if @q.sorts.empty?
      @workshops = @q.result(distinct: true).includes(:workshop_type).page(params[:page])
    end

    def new
      @workshop = Workshop.new
    end

    def create
      @workshop = Workshop.new(filtered_params)
      if @workshop.save
        flash[:success] = t('create.success')
        redirect_to admin_workshop_path @workshop
      else
        set_workshop_types
        render 'new', status: :unprocessable_entity
      end
    end

    def update
      if @workshop.update(filtered_params)
        flash[:success] = t('update.success')
        redirect_to admin_workshop_path @workshop
      else
        set_workshop_types
        render 'edit', status: :unprocessable_entity
      end
    end

    def destroy
      if @workshop.destroy
        flash[:success] = t('destroy.success')
        redirect_to admin_workshops_path
      else
        flash[:error] = t('destroy.failure')
        redirect_to admin_workshop_path @workshop
      end
    end

    def upload_images
      @workshop.workshop_images.attach(file_params)
      flash[:success] = t('upload.success')
      redirect_to admin_workshop_path(@workshop)
    end

    def clone
      clone = @workshop.clone
      clone.name += ' copy'
      if clone.save!
        flash[:success] = 'Project was successfully cloned!'
        redirect_to admin_workshop_path(clone)
      else
        flash[:error] = 'Sorry, an error occurred.'
        redirect_to admin_workshop_path @workshop
      end
    end

    private

    def workshop_params
      params.require(:workshop).permit(:name, :description, :purchase_start_date, :purchase_end_date, :start_date,
                                       :end_date, :overridden_single_seat_allow, :overridden_reservation_allow,
                                       :overridden_total_seats, :overridden_reservation_allow_multiple,
                                       :overridden_reservation_price, :overridden_reservation_minimum,
                                       :overridden_reservation_cancel_minimum_not_met, :overridden_reservation_maximum,
                                       :overridden_reservation_allow_guest_cancel_seat, :is_for_sale, :workshop_type_id,
                                       :family_friendly, project_ids: [])
    end

    def project_params
      params.require(:project_workshop).permit(:project_id, :workshop_id)
    end

    def file_params
      params[:workshop][:images]
    end

    def populate_workshop
      @workshop = Workshop.includes(:seats, :projects).find(params[:id])
    end

    def set_workshop_types
      @workshop_types = WorkshopType.all.order(:name)
    end

    def filtered_params
      parameters = workshop_params
      parameters[:project_ids]&.reject!(&:blank?)
      parameters[:purchase_start_date] = convert_datetime(parameters[:purchase_start_date])
      parameters[:purchase_end_date] = convert_datetime(parameters[:purchase_end_date])
      parameters[:start_date] = convert_datetime(parameters[:start_date])
      parameters[:end_date] = convert_datetime(parameters[:end_date])
      parameters
    end
  end
end
