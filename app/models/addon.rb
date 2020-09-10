# frozen_string_literal: true

class Addon < ApplicationRecord
  has_paper_trail
  has_many :project_addons, dependent: :destroy
  has_many_attached :addon_images, dependent: :destroy
  validates_presence_of :name, :price

  default_scope { order(name: :asc) }
  scope :active, -> { where(active: true) }
end
