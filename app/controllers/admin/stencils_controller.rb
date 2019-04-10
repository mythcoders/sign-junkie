module Admin
  class StencilsController < AdminController
    before_action :set_stencil, only: %i(edit)

    def index
      @stencils = Stencil.page(params[:page]).per(10)
    end

    private

    def set_stencil
      @stencil = Stencil.find(params[:id])
    end
  end
end
