# frozen_string_literal: true

class GalleryImage < ApplicationRecord
  has_one_attached :image, dependent: :destroy

  class << self
    def all_images
      ActiveStorage::Attachment.where(record_type: "GalleryImage")
    end

    def mass_attach(params)
      params.each do |img|
        create!(image: img)
      end
    end
  end
end
