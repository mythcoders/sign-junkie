# frozen_string_literal: true

module Admin
  class ColorsController < AdminController
    before_action :set_color, only: %i[edit update destroy]

    def index
      @q = Color.ransack(params[:q])
      @q.sorts = "name asc" if @q.sorts.empty?
      @colors = @q.result(distinct: true).page(params[:page])
    end

    def new
      @color = Color.new
    end

    def create
      @color = Color.new(color_params)

      if @color.save
        flash[:success] = t("create.success")
        redirect_to edit_admin_color_path(@color)
      else
        render "new", status: :unprocessable_entity
      end
    end

    def update
      if @color.update(color_params)
        flash[:success] = t("update.success")
        redirect_to edit_admin_color_path(@color)
      else
        render "edit", status: :unprocessable_entity
      end
    end

    def destroy
      if @color.destroy
        flash[:success] = t("destroy.success")
        redirect_to admin_colors_path
      else
        flash[:error] = t("destroy.failure")
        redirect_to edit_admin_color_path(@color)
      end
    end

    private

    def color_params
      params.require(:color).permit(:name, :color_type, :hex_code, :active)
    end

    def set_color
      @color = Color.find(params[:id])
    end
  end
end
