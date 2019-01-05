class CartItem < ApplicationRecord
  audited

  scope :for, ->(user) { where(user_id: user.id).order(:id) unless user.nil? }
  scope :as_of, -> { where('created_at <= CURRENT_TIMESTAMP') }
  scope :as_of, ->(date_created) { where('created_at <= ?', date_created) unless date_created.nil? }

  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
  belongs_to :workshop

  def self.find_or_new(user_id, workshop, quantity)
    item = CartItem.where(user_id: user_id, workshop_id: workshop.id).first
    if item.nil?
      item = CartItem.new(user_id: user_id, workshop_id: workshop.id, quantity: quantity)
    else
      item.quantity += quantity.to_i
    end
    item
  end

  def amount
    event.ticket_price * quantity
  end
end
