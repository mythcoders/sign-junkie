class Addon < ApplicationRecord
  has_many :project_addons
  has_many_attached :addon_images
  validates_presence_of :name, :price
end
