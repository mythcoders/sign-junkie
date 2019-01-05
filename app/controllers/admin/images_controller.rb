# frozen_string_literal: true

module Admin
  class ImagesController < AdminController
    before_action :get, only: %i[new create destroy]

    def create
      @workshop.images.attach(file_params)
      flash['success'] = t('UploadSuccess')
      redirect_to admin_workshop_path(@workshop)
    end

    def destroy
      @workshop.images.find(params[:id]).purge
      flash['success'] = t('DeleteSuccess')
      redirect_to admin_workshop_path(@workshop)
    end

    private

    def get
      @workshop = Workshop.find(params[:workshop_id])
    end

    def file_params
      params[:workshop][:images]
    end
  end
end
