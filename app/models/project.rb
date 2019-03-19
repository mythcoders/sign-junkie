class Project < ApplicationRecord
  has_many :addons, class_name: 'ProjectAddon'
  has_many :project_stencils
  has_many :project_workshops
  has_many :stencils, through: :project_stencils
  has_many :workshops, through: :project_workshops
  has_many_attached :project_images
end
