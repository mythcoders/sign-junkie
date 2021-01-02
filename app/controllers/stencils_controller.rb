# frozen_string_literal: true

class StencilsController < ApplicationController
  def index
    @categories = StencilCategory.includes(stencils: [{ image_attachment: :blob }])
  end
end
