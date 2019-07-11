# frozen_string_literal: true

class ProjectAddon < ApplicationRecord
  belongs_to :project
  belongs_to :addon
end
