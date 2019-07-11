# frozen_string_literal: true

module Admin
  class SettingsController < AdminController
    def index
      @addons = Addon.all
    end
  end
end
