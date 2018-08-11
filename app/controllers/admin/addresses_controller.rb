# frozen_string_literal: true

module Admin
  class AddressesController < ApplicationController

    before_action :get, only: %i[edit show update]

    def new
      @address = Address.new(user_id: params[:customer_id], state: 'OH')
    end

    def create
      @address = Address.new(address_params)
      if @address.save
        flash['success'] = t('CreateSuccess')
        redirect_to admin_customer_path @address.customer
      else
        render 'new'
      end
    end

    def update
      if @address.update(address_params)
        flash['success'] = t('UpdateSuccess')
        redirect_to admin_customer_path @address.customer
      else
        render 'edit'
      end
    end

    private

    def get
      @address = Address.includes(:customer).find(params[:id])
    end

    def address_params
      params.require(:address)
          .permit(:id, :user_id, :street, :street2, :city, :state,
                  :zip_code, :is_shipping, :is_billing)
    end

  end

end