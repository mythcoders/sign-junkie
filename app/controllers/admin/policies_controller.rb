# frozen_string_literal: true

module Admin
  class PoliciesController < AdminController
    before_action :set_policy, only: %i[edit update destroy]

    def index
      @q = Policy.ransack(params[:q])
      @q.sorts = "start_at asc" if @q.sorts.empty?
      @policies = @q.result(distinct: true).page(params[:page])
    end

    def new
      @policy = Policy.new
    end

    def create
      @policy = Policy.new(policy_params)

      if @policy.save
        flash[:success] = t("create.success")
        redirect_to admin_policy_path @policy
      else
        render "new", status: :unprocessable_entity
      end
    end

    def update
      if @policy.update(policy_params)
        flash[:success] = t("update.success")
        redirect_to admin_policy_path @policy
      else
        render "edit", status: :unprocessable_entity
      end
    end

    def destroy
      if @policy.destroy
        flash[:success] = t("destroy.success")
        redirect_to admin_policies_path
      else
        flash[:error] = t("destroy.failure")
        redirect_to admin_policy_path(@policy)
      end
    end

    private

    def policy_params
      params.require(:policy).permit(:name, :title, :content)
    end

    def set_policy
      @policy = Policy.find(params[:id])
    end
  end
end
