class Project < ApplicationRecord
  has_many :addons
  has_many :project_stencils
  has_many :project_workshops
  has_many :stencils, through: :project_stencils
  has_many :workshops, through: :project_workshops
end
