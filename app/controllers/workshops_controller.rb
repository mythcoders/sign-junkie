# frozen_string_literal: true

class WorkshopsController < ApplicationController
  before_action :get, only: [:show]
  before_action :populate_cart

  def index
    redirect_to home_path
  end

  private

  def get
    @workshop = Workshop.find(params[:id])
    # redirect_to home_path unless @workshop.active?
  end

  def populate_cart
    @cart_total = CartItem.for(current_user).count
  end
end
