class PublicController < ApplicationController
  before_action :set_cart_total
  before_action :authenticate_user!, only: %i[my_account]

  def index
    @view = params[:view] || 'grid'
    @events = if params[:search]
                Event.search(params[:terms], params[:sort])
              else
                Event.active
              end
  end

  def my_account
    @orders = Order.current(current_user.id)
  end
end
