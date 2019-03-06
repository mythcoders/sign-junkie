class StencilCategory < ApplicationRecord
  has_many :stencils
  belongs_to :stencil_category, optional: true
end
