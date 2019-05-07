module Admin
  class StencilsController < AdminController
    before_action :set_stencil, only: %i(edit)

    def index
      @stencils = Stencil.page(params[:page]).per(10)
    end

    def new
      @stencil = Stencil.new
      set_values_for_dropdown
    end

    def create
      @stencil = Stencil.new(stencil_params)

      if @stencil.save
        flash[:success] = t('CreateSuccess')
        redirect_to admin_stencils_path
      else
        set_values_for_dropdown
        render 'new'
      end
    end

    def update
      if @stencil.update(stencil_params)
        flash[:success] = t('CreateSuccess')
        redirect_to admin_stencils_path
      else
        set_values_for_dropdown
        render 'edit'
      end
    end

    private

    def stencil_params
      params.require(:stencil).permit(:id, :name, :stencil_category_id)
    end

    def set_stencil
      @stencil = Stencil.find(params[:id])
    end

    def set_values_for_dropdown
      @categories = StencilCategory.all
    end
  end
end
