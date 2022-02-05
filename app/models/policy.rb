# frozen_string_literal: true

class Policy < ApplicationRecord
  has_many :workshop_types
  has_rich_text :content

  before_validation :slugify

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :title, presence: true

  private

  def slugify
    self.slug = title.parameterize if slug.blank?
  end
end
