class StencilCategory < ApplicationRecord
  has_many :stencils
  has_many :stencil_categories, foreign_key: 'parent_id'
  belongs_to :parent_category, optional: true,
             class_name: 'StencilCategory', foreign_key: 'parent_id'

  scope :for_tree, -> { where(parent_id: nil).order(:name) }

  def to_builder
    Jbuilder.new do |node|
      node.label name
      node.value id

      node.children stencil_categories do |category|
        cateogry.to_builder
      end

      node.children stencils do |stencil|
        stencil.to_builder
      end
    end
  end
end
