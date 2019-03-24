class StencilCategory < ApplicationRecord
  has_many :stencils
  has_many :stencil_categories, foreign_key: 'parent_id'
  belongs_to :stencil_category, optional: true

  scope :for_tree, -> { where(parent_id: nil).order(:name) }

  def to_builder
    Jbuilder.new do |node|
      node.title name
      node.key id
      break unless stencil_categories.any?

      node.children stencil_categories do |stencil|
        stencil.to_builder
      end
    end
  end
end
