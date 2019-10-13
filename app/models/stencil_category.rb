# frozen_string_literal: true

class StencilCategory < ApplicationRecord
  has_paper_trail
  has_many :stencils, dependent: :destroy
  has_many :stencil_categories, foreign_key: 'parent_id'
  belongs_to :parent_category, optional: true,
                               class_name: 'StencilCategory',
                               foreign_key: 'parent_id'

  scope :with_stencils, -> { joins(:stencils).group('stencil_categories.id') }
  default_scope { order(name: :asc) }

  validates_presence_of :name

  def self.to_dropdown
    all.map { |i| [i.name, i.id] }
  end
end
