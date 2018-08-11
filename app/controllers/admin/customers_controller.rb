# frozen_string_literal: true

module Admin
  class CustomersController < ApplicationController

    before_action :get, only: %i[edit show update]

    def index
      @customers = User.customer.order(:last_name).page(params[:page]).per(10)
    end

    def new
      @customer = User.new
    end

    def create
      @customer = User.new(customer_params)

      if @customer.save
        flash['success'] = t('CreateSuccess')
        redirect_to admin_customer_path @customer
      else
        render 'new'
      end
    end

    def update
      if @customer.update(customer_params)
        flash['success'] = t('UpdateSuccess')
        redirect_to admin_customer_path @customer
      else
        render 'edit'
      end
    end

    private

    def customer_params
      params.require(:user).permit(:id, :first_name, :middle_name, :last_name,
                                   :email, :password, :role, :phone_number)
    end

    def get
      @customer = User.includes(:notes, :addresses).find(params[:id])
    end
  end
end
