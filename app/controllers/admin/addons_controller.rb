module Admin
  class AddonsController < AdminController
    def create
      @addon = Addon.new(addon_params)

      if @addon.save
        respond_to do |format|
          format.js { render :create }
        end
      else
        respond_to do |format|
          format.js { render :create_fail }
        end
      end
    end

    private

    def addon_params
      params.require(:addon).permit(:project_id, :name, :price)
    end
  end
end
