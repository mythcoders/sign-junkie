# frozen_string_literal: true

class ProjectColor < ApplicationRecord
  belongs_to :project
  belongs_to :color

  validates :project, presence: true
  validates :color, presence: true
end
