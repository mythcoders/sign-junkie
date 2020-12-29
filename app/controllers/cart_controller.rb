# frozen_string_literal: true

class CartController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart_service, only: %i[create destroy]

  def index
    @cart = Cart.for(current_user)
  end

  def create
    begin
      raise ProcessError, t('cart.add.failure') unless @service.add(current_user, cart_params)

      flash[:success] = t('cart.add.success')
      return redirect_to cart_index_path
    rescue ProcessError => e
      flash[:error] = e.message
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    if @service.remove(current_user, params)
      flash[:success] = t('cart.update.success')
    else
      flash[:error] = t('destroy.failure')
    end

    redirect_to cart_index_path
  end

  private

  def set_cart_service
    @service = CartService.new
  end

  def cart_params
    params.require(:cart).permit CartService.permitted_params
  end
end
