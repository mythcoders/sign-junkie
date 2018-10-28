class PublicController < ApplicationController
  before_action :set_cart_total
  before_action :authenticate_user!, only: %i[my_account]

  def index
    if show
      render 'coming_soon'
    else
      @view = params[:view] || 'grid'
      @events = if params[:search]
                  Event.search(params[:terms], params[:sort])
                else
                  Event.active
                end
    end
  end

  def show
    Rails.env.production? || params[:soon]
  end

  def my_account
    @orders = Order.current(current_user.id)
  end
end
