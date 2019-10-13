# frozen_string_literal: true

module Admin
  class ImagesController < AdminController
    def destroy
      image = ActiveStorage::Attachment.find(params[:id])
      image.purge
      flash[:success] = 'Image deleted successfully!'
      redirect_back(fallback_location: admin_dashboard_path)
    end
  end
end
