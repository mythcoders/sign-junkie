# frozen_string_literal: true

class CartController < ApplicationController
  helper WorkshopsHelper
  before_action :authenticate_user!

  def index
    @cart = Cart.for(current_user)
    @cart_subtotal = (@cart.map(&:item_amount).reduce(:+) || 0.00).round(2)
    @cart_count = @cart.count
    @estimated_tax = calc_est_tax
    @cart_total = @cart_subtotal + @estimated_tax
  end

  def create
    raise ProcessError, t('cart.add.failure') unless cart_service.add(current_user, cart_params)

    flash[:success] = t('cart.add.success')
    redirect_to cart_index_path
  rescue ProcessError => e
    flash[:error] = e.message
    redirect_back(fallback_location: root_path)
  end

  def destroy
    if cart_service.remove(current_user, params)
      flash[:success] = t('cart.update.success')
    else
      flash[:error] = t('destroy.failure')
    end

    redirect_to cart_index_path
  end

  private

  def cart_service
    @cart_service ||= CartService.new
  end

  def cart_params
    params.permit(:id, :quantity, :workshop_id, :project_id, :addon_id, :stencil_id, :stencil, :seating, :type,
                  :first_name, :last_name, :email, :amount, :gift_seat, :payment_plan, :seat_id, :reservation_id,
                  :guest_type)
  end

  def calc_est_tax
    taxable = @cart.select(&:taxable?)
    if taxable.any?
      (taxable.map(&:tax_amount).reduce(:+) || 0.00).round(2)
    else
      0.00
    end
  end
end
