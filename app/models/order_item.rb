class OrderItem < ApplicationRecord
  audited
  belongs_to :order
  belongs_to :event, autosave: true

  validates :name, presence: true
  validates :price, presence: true
  validates :quantity, presence: true

  def self.create(event, qty)
    OrderItem.new(name: event.name,
                  price: event.ticket_price,
                  quantity: qty,
                  event: event)
  end

  def item_total
    price * quantity
  end
end
