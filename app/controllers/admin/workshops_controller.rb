# fronzen_string_literal: true

module Admin
  class WorkshopsController < AdminController
    before_action :populate_workshop, only: %i[edit update show destory projects]

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

    def projects
      if request.post?
        add_projects_to_workshop
      else
        render 'projects'
      end
    end

    private

    def add_projects_to_workshop

    end

    def workshop_params
      params.require(:workshop).permit(:id, :name, :description, :posting_start_date,
                                       :posting_end_date, :start_date, :end_date,
                                       :total_tickets, :ticket_price, :is_for_sale,
                                       :is_public)
    end

    def populate_workshop
      @workshop = Workshop.includes(:order_items, :projects).find(params[:id])
    end

    def filtered_params
      parameters = workshop_params
      parameters[:posting_start_date] = convert_datetime(parameters[:posting_start_date])
      parameters[:posting_end_date] = convert_datetime(parameters[:posting_end_date])
      parameters[:start_date] = convert_datetime(parameters[:start_date])
      parameters[:end_date] = convert_datetime(parameters[:end_date])
      parameters
    end
  end
end
