# frozen_string_literal: true

class AddressesController < ApplicationController
  before_action :get, only: %i[edit show update]
  before_action :set_cart_total

  def index
    @addresses = current_user.addresses.order(is_default: :desc)
  end

  def new
    @address = Address.new(user_id: current_user.id, state: 'OH', country: 'USA')
  end

  def create
    @address = Address.new(address_params)
    if @address.save
      flash['success'] = t('CreateSuccess')
      redirect_to addresses_path
    else
      render 'new'
    end
  end

  def update
    if @address.update(address_params)
      flash['success'] = t('UpdateSuccess')
      redirect_to addresses_path
    else
      render 'edit'
    end
  end

  private

  def get
    @address = Address.includes(:customer).find(params[:id])
  end

  def address_params
    params.require(:address).permit(:id,
                                    :user_id,
                                    :street,
                                    :street2,
                                    :city,
                                    :state,
                                    :zip_code,
                                    :country,
                                    :is_default,
                                    :nickname)
  end
end
