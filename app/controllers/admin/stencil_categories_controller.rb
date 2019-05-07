module Admin
  class StencilCategoriesController < AdminController
    before_action :set_category, only: %i[update edit]
    before_action :set_values_for_dropdown, only: %i[new edit]

    def index
      @categories = StencilCategory.page(params[:page]).per(10)
    end

    def new
      @category = StencilCategory.new
    end

    def create
      @category = StencilCategory.new(stencil_params)

      if @category.save
        flash[:success] = t('CreateSuccess')
        redirect_to admin_stencil_categories_path
      else
        set_values_for_dropdown
        render 'new'
      end
    end

    def update
      if @category.update(stencil_params)
        flash[:success] = t('CreateSuccess')
        redirect_to admin_stencil_categories_path
      else
        set_values_for_dropdown
        render 'edit'
      end
    end

    private

    def stencil_params
      params.require(:stencil_category).permit(:id, :name, :parent_id)
    end

    def set_category
      @category = StencilCategory.find(params[:id])
    end

    def set_values_for_dropdown
      @categories = StencilCategory.all
    end
  end
end

