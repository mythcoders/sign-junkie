class StencilsController < ApplicationController
  def index
    @stencils = Stencil.order(name: :asc).all
  end
end
