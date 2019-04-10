class Project < ApplicationRecord
  has_many :project_addons
  has_many :project_stencils
  has_many :workshop_projects
  has_many :addons, through: :project_addons
  has_many :stencils, through: :project_stencils
  has_many :workshops, through: :workshop_projects
  has_many_attached :project_images

  def total_price
    material_price + instructional_price
  end
end
