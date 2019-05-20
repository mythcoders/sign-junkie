module Admin
  class StencilsController < AdminController
    before_action :set_stencil, only: %i(show edit update)
    before_action :set_values_for_dropdown, only: %i(new edit)

    def index
      @stencils = Stencil.order(:name).page(params[:page])
    end

    def new
      @stencil = Stencil.new
    end

    def create
      @stencil = Stencil.new(stencil_params)

      if @stencil.save
        flash[:success] = t('CreateSuccess')
        redirect_to admin_stencil_path @stencil
      else
        set_values_for_dropdown
        render 'new'
      end
    end

    def update
      if @stencil.update(stencil_params)
        flash[:success] = t('CreateSuccess')
        redirect_to admin_stencil_path @stencil
      else
        set_values_for_dropdown
        render 'edit'
      end
    end

    private

    def stencil_params
      params.require(:stencil).permit(:id, :name, :stencil_category_id, :image)
    end

    def set_stencil
      @stencil = Stencil.find(params[:id])
    end

    def set_values_for_dropdown
      @categories = StencilCategory.all.order(name: :asc)
    end
  end
end
