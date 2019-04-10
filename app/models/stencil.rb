class Stencil < ApplicationRecord
  belongs_to :category, class_name: 'StencilCategory', foreign_key: 'stencil_category_id'
end
