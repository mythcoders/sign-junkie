class PublicController < ApplicationController
  before_action :set_cart_total

  def index
    if show
      render 'coming_soon'
    else
      @view = params[:view] || 'grid'
      @workshops = if params[:search]
                  Workshop.search(params[:terms], params[:sort])
                else
                  Workshop.upcoming
                end
    end
  end

  def projects
    @project = Project.find(params[:project_id])
  end

  def show
    Rails.env.production? || params[:soon]
  end

  def tickets
    @upcoming_tickets = current_user.tickets.select { |t| t.workshop.start_date.future? }
    @past_tickets = current_user.tickets.select { |t| !t.workshop.start_date.future? }
  end
end
