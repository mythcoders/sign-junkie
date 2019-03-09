# frozen_string_literal: true

class CartController < ApplicationController
  helper WorkshopHelper
  before_action :authenticate_user!
  before_action :set_cart, only: %i[update destroy]
  before_action :check_cart_auth, only: %i[update destroy]

  def index
    @cart = Cart.for(current_user)
    @cart_total = @cart.count
  end

  def create
    workshop = Workshop.includes(:projects, :designs, :addons).find(params[:cart_item][:workshop_id])
    if workshop.can_purchase?
      if Cart.build(current_user, workshop, cart_params).save
        flash[:success] = t('cart.add.success')
      else
        flash[:error] = t('cart.add.failure')
      end
    else
      flash[:error] = t('cart.add.failure')
    end

    redirect_back(fallback_location: home_path)
  end

  def update
    # TODO: make sure not adding more than what's available
    # TODO: only update the quantity
    unless @cart_item.update(cart_params)
      flash[:error] = t('cart.update.failure')
    end

    redirect_to cart_index_path
  end

  def destroy
    if @cart_item.delete
      flash[:success] = t('cart.update.success')
    else
      flash[:error] = t('failure.delete')
    end

    redirect_to cart_index_path
  end

  private

  def set_cart
    @cart_item = Cart.find(params[:id])
  end

  def cart_params
    params.require(:cart_item).permit(:id, :quantity, :workshop_id, :project_id, :addon_id,
                                      :design_id, :design, :seating)
  end

  def check_cart_auth
    unauthorized if @cart_item.user_id != current_user.id
  end
end
