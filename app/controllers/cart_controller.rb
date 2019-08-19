# frozen_string_literal: true

class CartController < ApplicationController
  helper WorkshopHelper
  before_action :authenticate_user!
  before_action :set_cart_service, only: %i[create destroy]

  def index
    @cart = Cart.for(current_user)
    @cart_subtotal = (@cart.map(&:item_amount).reduce(:+) || 0.00).round(2)
    @cart_count = @cart.count
    @estimated_tax = calc_est_tax
    @cart_total = @cart_subtotal + @estimated_tax
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
      flash[:error] = t('failure.delete')
    end

    redirect_to cart_index_path
  end

  private

  def set_cart_service
    @service = CartService.new
  end

  def cart_params
    params.require(:cart).permit(:id, :quantity, :workshop_id, :project_id, :addon_id,
                                 :stencil_id, :stencil, :seating, :design_confirmation,
                                 :policy_agreement, :first_name, :last_name, :email,
                                 :amount, :type, :acknowledgment, :gift_seat, :payment_plan)
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
