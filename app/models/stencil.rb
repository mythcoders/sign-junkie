class Stencil < ApplicationRecord
  belongs_to :category, class_name: 'StencilCategory', foreign_key: 'stencil_category_id'

  def to_builder
    Jbuilder.new do |node|
      node.label name
      node.value id
    end
  end
end
