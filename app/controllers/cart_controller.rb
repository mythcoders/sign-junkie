# frozen_string_literal: true

class CartController < ApplicationController
  helper WorkshopHelper
  before_action :authenticate_user!
  before_action :set_cart_service, only: %i[create destroy]

  def index
    @cart = Cart.for(current_user)
    @cart_subtotal = @cart.map(&:total).inject(0, :+)
    @cart_count = @cart.count

    @reservation_fee = calc_reservation_fee
    @estimated_tax = calc_est_tax
    @cart_total = @cart_subtotal + @reservation_fee + @estimated_tax
  end

  def create
    begin
      if @service.add(current_user, cart_params)
        flash[:success] = t('cart.add.success')
        return redirect_to cart_index_path
      else
        raise Services::ProcessError, t('cart.add.failure')
      end
    rescue Services::ProcessError => e
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
    @service = Services::CartService.new
  end

  def cart_params
    params.require(:cart).permit(:id, :quantity, :workshop_id, :project_id, :addon_id,
                                 :stencil_id, :stencil, :seating, :design_confirmation,
                                 :policy_agreement, :first_name, :last_name, :email,
                                 :amount, :type)
  end

  def calc_est_tax
    taxable = @cart.select { |item| item.taxable? }
    if taxable.any?
      service = Services::TaxService.new
      taxable.collect { |item| service.calc_tax(item.description) }.first
    else
      0.00
    end
  end

  def calc_reservation_fee
    reservations = @cart.select { |item| item.reservation? }
    if reservations.any?
      0.00
    else
      0.00
    end
  end
end
