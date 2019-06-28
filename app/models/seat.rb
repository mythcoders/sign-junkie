class Seat < ApplicationRecord
  has_paper_trail
  belongs_to :reservation, optional: true
  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
  belongs_to :workshop
  belongs_to :description, class_name: 'ItemDescription', foreign_key: 'item_description_id'

  scope :for_user, ->(user) { where(user_id: user.id).order(:id) unless user.nil? }
  scope :for_shop, ->(id) { includes(:description).where(item_descriptions: { workshop_id: id }) }
  scope :active, -> { includes(:description).where(item_descriptions: { cancel_date: nil, void_date: nil }) }

  delegate_missing_to :description

  def invoice
    description.invoice_items.first.invoice
  end

  def self.already_booked?(user, workshop_id)
    Seat.for_user(user)
        .for_shop(workshop_id)
        .active
        .any?
  end
end
