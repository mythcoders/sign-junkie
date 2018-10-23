# frozen_string_literal: true

class AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :get, only: %i[edit update]
  before_action :set_cart_total, only: %i[index edit new]
  before_action :check_address_auth, only: %i[edit update]

  def index
    @addresses = current_user.addresses
  end

  def new
    @address = Address.new(user_id: current_user.id, state: 'OH')
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
    params.require(:address).permit(:id,  :user_id, :street, :street2, :city, :state, :zip_code,
                                    :is_default, :nickname)
  end

  def check_address_auth
    unauthorized if @address.user_id != current_user.id
  end
end
