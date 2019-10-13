# frozen_string_literal: true

module Purchaseable
  extend ActiveSupport::Concern

  included do
    scope :active, -> { includes(:description).where(item_descriptions: { void_date: nil, cancel_date: nil }) }
    scope :for_shop, ->(id) { includes(:description).where(item_descriptions: { workshop_id: id }) }

    belongs_to :description, class_name: 'ItemDescription', foreign_key: 'item_description_id'
    delegate_missing_to :description
    accepts_nested_attributes_for :description
  end

  def active?
    !voided? && !canceled?
  end
end
