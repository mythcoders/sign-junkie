module Admin
  class AddonsController < AdminController
    before_action :set_addon, only: %i(edit)

    def index
      @addons = Addon.page(params[:page]).per(10)
    end

    def new
      @addon = Addon.new
    end

    def create

    end

    def update

    end

    private

    def set_addon
      @addon = Addon.find(params[:id])
    end
  end
end
