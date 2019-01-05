# frozen_string_literal: true

class CartController < ApplicationController
  before_action :authenticate_user!
  before_action :get, only: %i[update destroy]
  before_action :check_cart_auth, only: %i[update destroy]

  def index
    @cart = CartItem.for(current_user)
    @cart_total = @cart.count
  end

  def create
    event = Event.find(params[:cart][:event_id])
    if event.can_purchase?
      add_to_cart(event)
    else
      flash[:error] = t('cart.add.failure')
    end
    redirect_back(fallback_location: home_path)
  end

  def update
    # TODO: make sure not adding more than what's available
    if @cart_item.update(cart_params)
      flash[:success] = t('cart.update.success')
    else
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

  def get
    @cart_item = CartItem.find(params[:id])
  end

  def add_to_cart(event)
    cart_item = CartItem.find_or_new(current_user.id, event, params[:cart][:quantity])
    if cart_item.save
      flash[:success] = t('cart.add.success')
    else
      flash[:error] = t('cart.add.failure')
    end
  end

  def cart_params
    params.require(:cart_item).permit(:id, :quantity)
  end

  def check_cart_auth
    unauthorized if @cart_item.user_id != current_user.id
  end
end
