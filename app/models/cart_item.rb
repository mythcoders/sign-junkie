class CartItem < ApplicationRecord
  audited
  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
  belongs_to :event

  scope :for, ->(user) { where(user_id: user.id).order(:id) unless user.nil? }


  def self.find_or_new(user_id, event, quantity)
    item = CartItem.where(user_id: user_id, event_id: event.id).first
    if item.nil?
      item = CartItem.new(user_id: user_id, event_id: event.id, quantity: quantity)
    else
      item.quantity += quantity.to_i
    end
    item
  end

  def amount
    event.ticket_price * quantity
  end
end
