class OrderItem < ApplicationRecord
  audited
  belongs_to :order, required: false
  belongs_to :payment, required: false
  belongs_to :workshop
  belongs_to :assignee, class_name: 'User', foreign_key: 'user_id', required: false

  validates :description, presence: true

  def self.create(cart)
    item = OrderItem.new(
      price: cart.price,
      for_deposit: false,
      workshop: cart.workshop,
      notified: false,
      prepped: false,
      seating: nil,
      design: cart.design.present? ? cart.design.name : nil,
      addon: cart.addon.present? ? cart.addon.name : nil,
      project: cart.project.present? ? cart.project.name : nil,
      identifier: SecureRandom.uuid
    )
    item.assignee = cart.customer if item.workshop.is_public?
    item
  end

  def self.deposit(cart)
    OrderItem.new(
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
    value = 0.0
    value += 1 if assignee.present?
    value += 1 if project.present? && design.present?
    value += 1 if payment.present?
    value / 3
  end

  def description
    if for_deposit
      "Deposit for #{workshop.name}"
    else
      val = ''
      val << " #{project}" if project.present?
      val << " (#{design})" if design.present?
      val << " w/ #{addon}" if addon.present?
      val
    end
  end
end
