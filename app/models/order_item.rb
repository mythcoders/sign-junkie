class OrderItem < ApplicationRecord
  audited
  belongs_to :order
  belongs_to :workshop, autosave: true

  validates :name, presence: true
  validates :price, presence: true
  validates :quantity, presence: true

  def self.create(workshop, qty)
    OrderItem.new(name: workshop.name,
                  price: workshop.ticket_price,
                  quantity: qty,
                  workshop: workshop)
  end

  def item_total
    price * quantity
  end
end
