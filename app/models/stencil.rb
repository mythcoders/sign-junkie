class Stencil < ApplicationRecord
  has_paper_trail
  belongs_to :category, class_name: 'StencilCategory', foreign_key: 'stencil_category_id'
  has_one_attached :image, :dependent => :destroy
  has_many :project_stencils, :dependent => :destroy

  default_scope { order(name: :asc) }
end

