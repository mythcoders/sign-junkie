class OrderItem < ApplicationRecord
  audited
  belongs_to :order

  validates :price, presence: true
  validates :name, presence: true
  validates :quantity, presence: true

  def self.create(event, qty, order)
    OrderItem.new(name: event.name,
                  price: event.ticket_price,
                  quantity: qty,
                  order: order)
  end

  def item_total
    price * quantity
  end
end
