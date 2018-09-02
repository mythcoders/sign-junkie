# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :get, only: [:show]
  before_action :populate_cart

  def index
    redirect_to home_path
  end

  private

  def get
    @event = Event.find(params[:id])
    # redirect_to home_path unless @event.active?
  end

  def populate_cart
    @cart_total = CartItem.for(current_user).count
  end
end
