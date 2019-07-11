# frozen_string_literal: true

class Project < ApplicationRecord
  has_paper_trail
  has_many :project_addons, dependent: :destroy
  has_many :project_stencils, dependent: :destroy
  has_many :workshop_projects, dependent: :destroy
  has_many :addons, through: :project_addons
  has_many :stencils, through: :project_stencils
  has_many :workshops, through: :workshop_projects
  has_many_attached :project_images, dependent: :destroy

  accepts_nested_attributes_for :addons, :stencils
  validates_presence_of :name, :material_price, :instructional_price

  default_scope { order(name: :asc) }

  def total_price
    material_price + instructional_price
  end
end
