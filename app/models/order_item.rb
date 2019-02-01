class OrderItem < ApplicationRecord
  audited
  belongs_to :order
  belongs_to :workshop, autosave: true

  validates :description, presence: true
  validates :price, presence: true
  validates :quantity, presence: true

  def self.create(cart)
    OrderItem.new(description: cart.display,
                  price: cart.workshop.ticket_price,
                  quantity: cart.quantity,
                  workshop: cart.workshop,
                  identifier: SecureRandom.uuid)
  end

  def self.deposit(workshop)
    OrderItem.new(description: "Deposit for #{workshop.name}",
                  price: Workshop.private_deposit,
                  quantity: 1,
                  workshop: workshop,
                  identifier: SecureRandom.uuid)
  end

  def item_total
    price * quantity
  end
end
