class Design < ApplicationRecord
  belongs_to :design_category, required: true
  has_many :project_designs

  validates_presence_of :name, :design_category
  validates_uniqueness_of :name
end
