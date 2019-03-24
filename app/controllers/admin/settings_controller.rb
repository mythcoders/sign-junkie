module Admin
  class SettingsController < AdminController
    def stencil_categories
      @data = StencilCategory.for_tree
    end
  end
end
