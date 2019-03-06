class ProjectWorkshop < ApplicationRecord
  belongs_to :project
  belongs_to :workshops
end
