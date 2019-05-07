class Addon < ApplicationRecord
  has_many :project_addons
  has_many_attached :addon_images
  validates_presence_of :name, :price

  def self.active
    Addon
      .order(name: :asc)
      .find(ProjectAddon.distinct.pluck(:addon_id))
  end
end
