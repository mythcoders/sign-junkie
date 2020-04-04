# frozen_string_literal: true

class Project < ApplicationRecord
  has_paper_trail
  has_many :project_addons, dependent: :destroy
  has_many :project_stencils, dependent: :destroy
  has_many :workshop_projects, dependent: :destroy
  has_many :addons, through: :project_addons
  has_many :stencils, through: :project_stencils
  has_many :workshops, through: :workshop_projects
  has_many_attached :project_images, dependent: :destroy

  accepts_nested_attributes_for :addons, :stencils
  validates_presence_of :name, :material_price, :instructional_price, :max_stencil_selection
  validates :max_stencil_selection, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 2 }

  default_scope { order(name: :asc) }

  def total_price
    material_price + instructional_price
  end

  def stencils_by_category
    results = []

    stencils.group_by(&:category)
            .sort_by { |category, _| category[:name].downcase }
            .each do |category, items|
      results << {
        category_name: category.name,
        stencils: items.sort_by { |stencil| stencil.name.downcase }
                       .map do |stencil|
                    {
                      id: stencil.id,
                      name: stencil.name,
                      personilization_allowed: stencil.allow_personilization
                    }
                  end
      }
    end

    results
  end
end
