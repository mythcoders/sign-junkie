class OrderItem < ApplicationRecord
  audited
  belongs_to :order
  has_many :tickets

  validates :description, presence: true
  validates :price, presence: true
  validates :quantity, presence: true

  accepts_nested_attributes_for :tickets

  def self.create(cart)
    item = OrderItem.new(description: cart.display,
                         price: cart.workshop.ticket_price,
                         quantity: cart.quantity,
                         deposit: false)
    item.quantity.times do
      item.tickets << Ticket.new(workshop: cart.workshop,
                                 project: cart.project,
                                 customization: cart.customization,
                                 addon: cart.addon,
                                 notified: false,
                                 identifier: SecureRandom.uuid)
    end
    item
  end

  def self.deposit(cart)
    OrderItem.new(description: "Deposit for #{cart.workshop.name}",
                  price: Workshop.private_deposit,
                  quantity: 1,
                  deposit: true)
  end

  def item_total
    price * quantity
  end
end
