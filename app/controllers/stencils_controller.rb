# frozen_string_literal: true

class StencilsController < ApplicationController
  before_action :set_stencil, only: %i[show]

  def index
    @categories = StencilCategory.includes(stencils: [{ image_attachment: :blob }])
  end

  private

  def set_stencil
    @stencil = Stencil.find params[:id]
  end
end
