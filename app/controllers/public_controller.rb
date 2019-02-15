class PublicController < ApplicationController
  before_action :set_cart_total
  before_action :authenticate_user!, only: %i[my_account]

  def index
    if show
      render 'coming_soon'
    else
      @view = params[:view] || 'grid'
      @workshops = if params[:search]
                  Workshop.search(params[:terms], params[:sort])
                else
                  Workshop.active
                end
    end
  end

  def projects
    @project = Project.find(params[:project_id])
  end

  def show
    Rails.env.production? || params[:soon]
  end

  def my_account
    @orders = Order.current(current_user.id)
  end
end
