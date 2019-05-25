module Admin
  class AddonsController < AdminController
    before_action :set_addon, only: %i(show edit update images destroy)

    def index
      @addons = Addon.order(:name).page(params[:page])
    end

    def new
      @addon = Addon.new
    end

    def create
      @addon = Addon.new(addon_params)

      if @addon.save
        flash[:success] = t('CreateSuccess')
        redirect_to admin_addon_path @addon
      else
        render 'new'
      end
    end

    def update
      if @addon.update(addon_params)
        flash[:success] = t('UpdateSuccess')
        redirect_to admin_addon_path @addon
      else
        render 'edit'
      end
    end

    def images
      @addon.addon_images.attach(file_params)
      flash['success'] = t('UploadSuccess')
      redirect_to admin_addon_path(@addon)
    end

    def destroy
      if @addon.destroy
        flash[:success] = t('destroy.success')
        redirect_to admin_addons_path
      else
        flash[:error] = t('destroy.failure')
        redirect_to admin_addon_path(@addon)
      end
    end

    private

    def addon_params
      params.require(:addon).permit(:id, :name, :price)
    end

    def file_params
      params[:addon][:images]
    end

    def set_addon
      @addon = Addon.find(params[:id])
    end
  end
end
