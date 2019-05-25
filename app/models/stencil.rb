class Stencil < ApplicationRecord
  has_paper_trail
  belongs_to :category, class_name: 'StencilCategory', foreign_key: 'stencil_category_id'
  has_one_attached :image

  def to_builder
    Jbuilder.new do |node|
      node.label name
      node.value id
    end
  end
end
