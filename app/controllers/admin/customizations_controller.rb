module Admin
  class CustomizationsController < AdminController
    before_action :set_customization, only: %i[edit update]

    def index
      @customizations = Customization.page(params[:page]).per(10)
    end

    def new
      @customization = Customization.new
    end

    def create
      @customization = Customization.new(customization_params)

      if @customization.save
        flash[:success] = t('CreateSuccess')
        redirect_to admin_customizations_path
      else
        render 'new'
      end
    end

    def update
      if @customization.update(customization_params)
        flash[:success] = t('CreateSuccess')
        redirect_to admin_customizations_path
      else
        render 'edit'
      end
    end

    private

    def customization_params
      params.require(:customization).permit(:id, :name, :category)
    end

    def set_customization
      @customization = Customization.find(params[:id])
    end
  end
end
