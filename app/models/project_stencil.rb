# frozen_string_literal: true

class ProjectStencil < ApplicationRecord
  belongs_to :project
  belongs_to :stencil
end
