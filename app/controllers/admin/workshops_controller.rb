# fronzen_string_literal: true

module Admin
  class WorkshopsController < AdminController
    before_action :populate_workshop, only: %i[edit update show destroy images]

    def index
      @workshops = Workshop.order(start_date: :desc).page(params[:page])
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

    def destroy
      if @workshop.destroy
        flash[:success] = t('destroy.success')
        redirect_to admin_workshops_path
      else
        flash[:error] = t('destroy.failure')
        redirect_to admin_workshop_path @workshop
      end
    end

    def images
      @workshop.workshop_images.attach(file_params)
      flash[:success] = t('UploadSuccess')
      redirect_to admin_workshop_path(@workshop)
    end

    def clone
      workshop = Workshop.find(filtered_params[:id])
      clone = workshop.deep_clone include: [ :workshop_projects ], exclude: [ :is_for_sale ]
      if clone.save!
        flash[:success] = 'Project was successfully cloned!'
        redirect_to admin_workshop_path(clone)
      else
        flash[:error] = 'Sorry, an error occured.'
        redirect_to admin_workshop_path @workshop
      end
    end

    private

    def workshop_params
      params.require(:workshop).permit(:id, :name, :description, :purchase_start_date,
                                       :purchase_end_date, :start_date, :end_date,
                                       :total_tickets, :ticket_price, :deposit_price, :is_for_sale,
                                       :is_public, :project_ids => [])
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
      parameters[:project_ids].reject!(&:blank?) if parameters[:project_ids]
      parameters[:purchase_start_date] = convert_datetime(parameters[:purchase_start_date])
      parameters[:purchase_end_date] = convert_datetime(parameters[:purchase_end_date])
      parameters[:start_date] = convert_datetime(parameters[:start_date])
      parameters[:end_date] = convert_datetime(parameters[:end_date])
      parameters
    end
  end
end
