# frozen_string_literal: true

class Color < ApplicationRecord
  has_many :project_colors

  default_scope { order(name: :asc) }
  scope :active, -> { where(active: true) }

  validates :name, presence: true
  validates :color_type, presence: true
  validates :hex_code, presence: true

  enum color_type: {
    paint: "paint",
    stain: "stain",
    both: "both"
  }
end
