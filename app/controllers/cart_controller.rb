# frozen_string_literal: true

class CartController < ApplicationController
  helper WorkshopHelper
  before_action :authenticate_user!
  before_action :set_cart_service, only: %i[create update destroy]

  def index
    @cart = Cart.for(current_user)
    @cart_total = @cart.count
  end

  def create
    begin
      if @service.add(current_user, cart_params)
        flash[:success] = t('cart.add.success')
      else
        raise Services::ProcessError, t('cart.add.failure')
      end
    rescue Services::ProcessError => e
      flash[:error] = e.message
    end

    redirect_back(fallback_location: home_path)
  end

  def update
    unless @service.update(current_user, cart_params)
      flash[:error] = t('cart.update.failure')
    end

    redirect_to cart_index_path
  end

  def destroy
    if @service.remove(current_user, params)
      flash[:success] = t('cart.update.success')
    else
      flash[:error] = t('failure.delete')
    end

    redirect_to cart_index_path
  end

  private

  def set_cart_service
    @service = Services::CartService.new
  end

  def cart_params
    params.require(:cart).permit(:id, :quantity, :workshop_id, :project_id, :addon_id,
                                 :stencil_id, :stencil, :seating, :design_confirmation,
                                 :policy_agreement)
  end
end
