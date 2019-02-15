module Admin
  class DesignCategoriesController < AdminController
    before_action :set_category, only: %i[update edit]
    before_action :set_values_for_dropdown, only: %i[new edit]

    def index
      @categories = DesignCategory.page(params[:page]).per(10)
    end

    def new
      @category = DesignCategory.new
    end

    def create
      @category = DesignCategory.new(design_params)

      if @category.save
        flash[:success] = t('CreateSuccess')
        redirect_to admin_design_categories_path
      else
        set_values_for_dropdown
        render 'new'
      end
    end

    def update
      if @category.update(design_params)
        flash[:success] = t('CreateSuccess')
        redirect_to admin_design_categories_path
      else
        set_values_for_dropdown
        render 'edit'
      end
    end

    private

    def design_params
      params.require(:design_category).permit(:id, :name, :parent_id)
    end

    def set_category
      @category = DesignCategory.find(params[:id])
    end

    def set_values_for_dropdown
      @categories = DesignCategory.all
    end
  end
end
