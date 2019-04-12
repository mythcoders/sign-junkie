class Addon < ApplicationRecord
  has_many :project_addons
  validates_presence_of :name, :price
end
