# fronzen_string_literal: true

module Admin
  class EventsController < AdminController
    before_action :populate_event, only: %i[edit update show destory]

    def index
      @events = Event.order(start_date: :desc).page(params[:page]).per(10)
    end

    def new
      @event = Event.new
    end

    def create
      @event = Event.new(filtered_params)
      if @event.save
        flash[:success] = t('CreateSuccess')
        redirect_to admin_event_path @event
      else
        render 'new'
      end
    end

    def update
      if @event.update(filtered_params)
        flash[:success] = t('UpdateSuccess')
        redirect_to admin_event_path @event
      else
        render 'edit'
      end
    end

    def destory
      if @event.destory!
        flash[:success] = t('DeleteSuccess')
      else
        flash[:error] = t('DeleteFailure')
      end
      redirect_to admin_events_path
    end

    private

    def event_params
      params.require(:event).permit(:id, :name, :description, :posting_start_date, :start_date, :end_date,
                                    :tickets_available, :ticket_price, :is_for_sale)
    end

    def populate_event
      @event = Event.find(params[:id])
    end

    def filtered_params
      parameters = event_params
      parameters[:posting_start_date] = convert_datetime(parameters[:posting_start_date])
      parameters[:start_date] = convert_datetime(parameters[:start_date])
      parameters[:end_date] = convert_datetime(parameters[:end_date])
      parameters
    end
  end
end
