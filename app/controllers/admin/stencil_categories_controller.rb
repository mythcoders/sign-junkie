# frozen_string_literal: true

module Admin
  class StencilCategoriesController < AdminController
    before_action :set_category, only: %i[update edit destroy]
    before_action :set_values_for_dropdown, only: %i[new edit]

    def index
      @q = StencilCategory.ransack(params[:q])
      @q.sorts = 'name asc' if @q.sorts.empty?
      @categories = @q.result(distinct: true).page(params[:page])
    end

    def new
      @category = StencilCategory.new
    end

    def create
      @category = StencilCategory.new(stencil_params)

      if @category.save
        flash[:success] = t('create.success')
        redirect_to admin_stencil_categories_path
      else
        render 'new'
      end
    end

    def update
      if @category.update(stencil_params)
        flash[:success] = t('create.success')
        redirect_to admin_stencil_categories_path
      else
        render 'edit'
      end
    end

    def destroy
      if @category.destroy
        flash[:success] = t('destroy.success')
        redirect_to admin_stencil_categories_path
      else
        flash[:error] = t('destroy.failure')
        redirect_to edit_admin_stencil_category_path(@category)
      end
    end

    private

    def stencil_params
      params.require(:stencil_category).permit(:name)
    end

    def set_category
      @category = StencilCategory.find(params[:id])
    end
  end
end
