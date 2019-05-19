# fronzen_string_literal: true

module Admin
  class WorkshopsController < AdminController
    before_action :populate_workshop, only: %i[edit update show destory images]

    def index
      @workshops = Workshop.order(start_date: :desc).page(params[:page]).per(10)
    end

    def new
      @workshop = Workshop.new
    end

    def create
      @workshop = Workshop.new(filtered_params)
      if @workshop.save
        flash[:success] = t('CreateSuccess')
        redirect_to admin_workshop_path @workshop
      else
        render 'new'
      end
    end

    def update
      if @workshop.update(filtered_params)
        flash[:success] = t('UpdateSuccess')
        redirect_to admin_workshop_path @workshop
      else
        render 'edit'
      end
    end

    def destory
      if @workshop.destory!
        flash[:success] = t('DeleteSuccess')
      else
        flash[:error] = t('DeleteFailure')
      end
      redirect_to admin_workshops_path
    end

    def images
      @workshop.workshop_images.attach(file_params)
      flash[:success] = t('UploadSuccess')
      redirect_to admin_workshop_path(@workshop)
    end

    def clone
      Workshop.clone params[:id]
    end

    private

    def workshop_params
      params.require(:workshop).permit(:id, :name, :description, :purchase_start_date,
                                       :purchase_end_date, :start_date, :end_date,
                                       :total_tickets, :ticket_price, :deposit_price, :is_for_sale,
                                       :is_public, :allow_custom_stencils, :project_ids => [])
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

    def filtered_params
      parameters = workshop_params
      parameters[:project_ids].reject!(&:blank?)
      parameters[:purchase_start_date] = convert_datetime(parameters[:purchase_start_date])
      parameters[:purchase_end_date] = convert_datetime(parameters[:purchase_end_date])
      parameters[:start_date] = convert_datetime(parameters[:start_date])
      parameters[:end_date] = convert_datetime(parameters[:end_date])
      parameters
    end
  end
end
