class Design < ApplicationRecord
  belongs_to :design_category, required: true

  validates_presence_of :name
  validates_uniqueness_of :name
end
