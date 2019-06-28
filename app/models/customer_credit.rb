class CustomerCredit < ApplicationRecord
  has_paper_trail
  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
  has_one :refund

  scope :not_expired, lambda {
    where(expiration_date: nil)
      .or(CustomerCredit.where('expiration_date >= current_timestamp'))
  }
  scope :with_balance, lambda { where('balance > 0') }
  scope :active, lambda { with_balance.not_expired }

  validates_presence_of :starting_amount, :balance, :user_id

  def self.deduct!(payment)
    remaining = payment.amount
    payment.invoice.customer.credits.active.each do |credit|
      if credit.balance >= remaining
        credit.balance -= remaining
        remaining -= remaining
      else
        credit.balance -= credit.balance
        remaining -= credit.balance
      end

      credit.save!
      break if remaining.zero?
    end

    return true
  end
end
