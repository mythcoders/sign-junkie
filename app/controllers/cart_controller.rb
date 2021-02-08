# frozen_string_literal: true

class CartController < ApplicationController
  before_action :authenticate_user!

  def index
    @cart = Cart.for(current_user)
  end

  def create
    raise ProcessError, t('cart.add.failure') unless CartFactory.process!(current_user, cart_params)

    flash[:success] = t('cart.add.success')
    redirect_to cart_index_path
  rescue ProcessError => e
    flash[:error] = e.message
    redirect_back(fallback_location: root_path)
  end

  def destroy
    if Cart.remove!(current_user, params[:id])
      flash[:success] = t('cart.update.success')
    else
      flash[:error] = t('destroy.failure')
    end

    redirect_to cart_index_path
  end

  private

  def cart_params
    params.require(:cart).permit CartFactory.permitted_params
  end
end
