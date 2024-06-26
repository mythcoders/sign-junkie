# frozen_string_literal: true

module Admin
  class EmployeesController < AdminController
    before_action :get, only: %i[edit show update]
    before_action :disable_roles, only: %i[edit update]

    def index
      @q = User.employees.ransack(params[:q])
      @q.sorts = "last_name asc" if @q.sorts.empty?
      @employees = @q.result(distinct: true).page(params[:page])
    end

    def new
      @employee = User.new
      @employee.role = :employee
    end

    def create
      @employee = User.invite!(employee_params.except(:id))
      if @employee
        flash["success"] = t("create.success")
        redirect_to admin_employee_path @employee
      else
        disabled_roles
        render "new", status: :unprocessable_entity
      end
    end

    def update
      if @employee.update(employee_params)
        flash["success"] = t("update.success")
        redirect_to admin_employee_path @employee
      else
        disabled_roles
        render "edit", status: :unprocessable_entity
      end
    end

    private

    def employee_params
      params.require(:user).permit(:first_name, :last_name, :role, :email)
    end

    def disable_roles
      @disabled_roles = current_user.operator? ? %i[] : %i[employee admin operator]
    end

    def get
      @employee = User.find(params[:id])
    end
  end
end
