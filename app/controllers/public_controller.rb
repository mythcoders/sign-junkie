class PublicController < ApplicationController
  before_action :set_cart_total
  before_action :authenticate_user!, only: %i[my_account]

  def index
    @view = params[:view] || 'grid'
    @events = if params[:search]
                # term = params[:terms]
                # low_price = params[:low_price]
                # high_price = params[:high_price]
                # sort = params[:sort]
                Event.all
              else
                Event.active
              end
  end

  def my_account
    @orders = Order.current(current_user.id)
  end
end
