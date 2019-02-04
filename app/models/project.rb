class Project < ApplicationRecord
  has_many :addons
  has_many :project_workshops
  has_many :workshops, through: :project_workshops

  accepts_nested_attributes_for :project_workshops, :addons
end
