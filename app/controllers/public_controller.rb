class PublicController < ApplicationController
  before_action :set_cart_total

  def project
    @workshop = Workshop.find(params[:workshop_id])
    @project = Project.find(params[:project_id])
  end

  def show
    Rails.env.production? || params[:soon]
  end

  def my_account
    # @upcoming_tickets = current_user.tickets.select { |t| t.workshop.start_date.future? }
    # @past_tickets = current_user.tickets.select { |t| !t.workshop.start_date.future? }
  end
end
