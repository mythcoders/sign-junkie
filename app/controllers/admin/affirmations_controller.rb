# frozen_string_literal: true

module Admin
  class AffirmationsController < AdminController
    before_action :set_affirmation, only: %i[edit update destroy]
    before_action :set_workshop_types, only: %i[edit update new]

    def index
      @q = Affirmation.ransack(params[:q])
      @q.sorts = "start_at asc" if @q.sorts.empty?
      @affirmations = @q.result(distinct: true).page(params[:page])
    end

    def new
      @affirmation = Affirmation.new
    end

    def create
      @affirmation = Affirmation.new(affirmation_params)

      if @affirmation.save
        flash[:success] = t("create.success")
        redirect_to edit_admin_affirmation_path(@affirmation)
      else
        set_workshop_types
        render "new", status: :unprocessable_entity
      end
    end

    def update
      if @affirmation.update(affirmation_params)
        flash[:success] = t("update.success")
        redirect_to edit_admin_affirmation_path(@affirmation)
      else
        set_workshop_types
        render "edit", status: :unprocessable_entity
      end
    end

    def destroy
      if @affirmation.destroy
        flash[:success] = t("destroy.success")
        redirect_to admin_affirmations_path
      else
        flash[:error] = t("destroy.failure")
        redirect_to edit_admin_affirmation_path(@affirmation)
      end
    end

    private

    def affirmation_params
      params.require(:affirmation).permit(:title, :content, :workshop_type_id, :active, :for_seats, :for_reservations)
    end

    def set_workshop_types
      @workshop_types = WorkshopType.all.order(:name)
    end

    def set_affirmation
      @affirmation = Affirmation.find(params[:id])
    end
  end
end
