# frozen_string_literal: true

# Debit given by the customer for an order
class Payment < ApplicationRecord
  audited
  belongs_to :order
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_user_id'
  belongs_to :taken_by, class_name: 'User', foreign_key: 'taken_by_user_id', optional: true

  enum status: %i[created authorized authorization_expired processor_declined
                  gateway_reject failed voided submitted settling settled
                  settlement_declined settlement_pending]

  validates_presence_of :order_id, :status, :amount, :method, :transaction_id
  before_create :can_make?

  def self.build(order_id, user_id)
    payment = Payment.new(status: :created)
    payment.order = Order.find(order_id)
    payment.user_id = user_id
    payment.method = payment.order.payment_method
    payment.amount = payment.order.total_balance
    payment.date_posted = Time.now
    payment
  end

  def process(params)
    return_value = false
    ActiveRecord::Base.transaction do
      service = Ares::PaymentService.new(self.order)
      result = service.post(params[:payment_method_nonce])
      return_value = service.process(result)
      if return_value
        self.status = :authorized
        self.transaction_id = result.transaction.id
        self.date_posted = Time.now
        save!
        order.place!
      end
    end
    return_value
  end

  def can_make?
    raise('keep yo money!') unless order.can_make_payment?
  end

  def paypal?
    method == 'paypal'
  end

  def in_progress?
    status == 'created'
  end

  def posted?
    date_posted.present?
  end

  def editable?
    status == :created
  end

  def self.new_client_token
    Ares::PaymentService.new_token
  end
end
