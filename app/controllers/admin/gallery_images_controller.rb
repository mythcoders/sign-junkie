# frozen_string_literal: true

module Admin
  class GalleryImagesController < AdminController
    def index
      @images = GalleryImage.all_images.page(params[:page])
    end

    def create
      if GalleryImage.mass_attach(params[:gallery][:images])
        flash["success"] = t("upload.success")
      else
        flash["error"] = t("upload.failure")
      end

      redirect_to admin_gallery_images_path
    end

    def destroy
      image = ActiveStorage::Attachment.find(params[:id])
      image.purge
      flash[:success] = "Image deleted successfully!"
      redirect_back(fallback_location: admin_gallery_images_path)
    end
  end
end
