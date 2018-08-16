# frozen_string_literal: true

module Admin
  class EmployeesController < ApplicationController
    before_action :get, only: %i[edit show update]
    before_action :disable_roles, only: %i[edit update]

    def index
      @employees = User.employees.order(:last_name).page(params[:page]).per(10)
    end

    def new
      @employee = User.new
      @employee.role = :employee
    end

    def create
      @employee = User.new(employee_params)
      if @employee.save
        flash['success'] = t('CreateSuccess')
        redirect_to admin_employee_path @employee
      else
        disabled_roles
        render 'new'
      end
    end

    def update
      if @employee.update(employee_params)
        flash['success'] = t('UpdateSuccess')
        redirect_to admin_employee_path @employee
      else
        disabled_roles
        render 'edit'
      end
    end

    private

    def employee_params
      params.require(:user).permit(:id, :first_name, :middle_name, :last_name,
                                   :phone_number, :role, :email, :password)
    end

    def disable_roles
      @disabled_roles = current_user.operator? ? %i[] : %i[employee admin operator]
    end

    def get
      @employee = User.find(params[:id])
    end
  end

end