# fronzen_string_literal: true

module Admin
  class WorkshopsController < AdminController
    before_action :populate_workshop, only: %i[edit update show destory]
    before_action :populate_projects, only: %i[show]

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

    def project
      @project = ProjectWorkshop.new(project_params)

      if @project.save
        flash[:success] = t('CreateSuccess')
      else
        flash[:error] = 'Error'
      end

      redirect_to admin_workshop_path @project.workshop_id
    end

    private

    def workshop_params
      params.require(:workshop).permit(:id, :name, :description, :purhcase_start_date,
                                       :purhcase_end_date, :start_date, :end_date,
                                       :total_tickets, :ticket_price, :is_for_sale,
                                       :is_public)
    end

    def project_params
      params.require(:project_workshop).permit(:project_id, :workshop_id)
    end

    def populate_projects
      @projects = Project.all
    end

    def populate_workshop
      @workshop = Workshop.includes(:tickets, :projects).find(params[:id])
    end

    def filtered_params
      parameters = workshop_params
      parameters[:purchase_start_date] = convert_datetime(parameters[:purhcase_start_date])
      parameters[:purchase_end_date] = convert_datetime(parameters[:purchase_end_date])
      parameters[:start_date] = convert_datetime(parameters[:start_date])
      parameters[:end_date] = convert_datetime(parameters[:end_date])
      parameters
    end
  end
end
