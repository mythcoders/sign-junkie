class DesignCategory < ApplicationRecord
  has_many :designs
  has_many :design_categories
  belongs_to :parent_category, required: false,
             class_name: 'DesignCategory', foreign_key: 'parent_id'

  before_validation :check_parent_reference

  private

  def check_parent_reference
    errors.add(:parent_id, 'can not be itself') if persisted? && parent_id == id
  end
end
