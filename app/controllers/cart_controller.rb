# frozen_string_literal: true

class CartController < ApplicationController
  before_action :authenticate_user!

  def index
    @cart = Cart.for(current_user)
  end

  def create
    begin
      if CartFactory.process(current_user, cart_params)
        flash[:success] = t('cart.add.success')

        return redirect_to cart_index_path
      else
        raise ProcessError, t('cart.add.failure')
      end
    rescue ProcessError => e
      flash[:error] = e.message
    end

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
