module Admin
  class SettingsController < AdminController
    def index
      @addons = Addon.all
      @data = StencilCategory.for_tree
    end
  end
end
