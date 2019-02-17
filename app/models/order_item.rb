class OrderItem < ApplicationRecord
  audited
  belongs_to :order, required: false
  belongs_to :payment, required: false
  belongs_to :workshop
  belongs_to :assignee, class_name: 'User', foreign_key: 'user_id', required: false

  validates :description, presence: true

  def self.create(cart)
    OrderItem.new(
      description: cart.display,
      price: cart.price,
      for_deposit: false,
      workshop: cart.workshop,
      notified: false,
      prepped: false,
      seating: nil,
      design: cart.design.present? ? cart.design.name : nil,
      identifier: SecureRandom.uuid
    )
  end

  def self.deposit(cart)
    OrderItem.new(
      description: "Deposit for #{cart.workshop.name}",
      price: Workshop.private_deposit,
      for_deposit: true,
      workshop: cart.workshop,
      notified: false,
      prepped: false,
      seating: nil,
      design: nil,
      identifier: SecureRandom.uuid,
      assignee: cart.customer
    )
  end

  def score
    0
  end
end
