module Admin
  class StencilsController < AdminController
    def index
      @stencils = Stencil.page(params[:page]).per(10)
    end
  end
end
