module Admin
  class DesignsController < AdminController
    before_action :set_design, only: %i[edit update]
    before_action :set_values_for_dropdown, only: %i[new edit]

    def index
      @designs = Design.page(params[:page]).per(10)
    end

    def new
      @design = Design.new
    end

    def create
      @design = Design.new(design_params)

      if @design.save
        flash[:success] = t('CreateSuccess')
        redirect_to admin_designs_path
      else
        set_values_for_dropdown
        render 'new'
      end
    end

    def update
      if @design.update(design_params)
        flash[:success] = t('CreateSuccess')
        redirect_to admin_designs_path
      else
        set_values_for_dropdown
        render 'edit'
      end
    end

    private

    def design_params
      params.require(:design).permit(:id, :name, :design_category_id)
    end

    def set_design
      @design = Design.find(params[:id])
    end

    def set_values_for_dropdown
      @categories = DesignCategory.all
    end
  end
end
