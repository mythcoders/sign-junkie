class StencilsController < ApplicationController
  def index
    @categories = StencilCategory.with_stencils
  end
end
