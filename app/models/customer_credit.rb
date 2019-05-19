class CustomerCredit < ApplicationRecord
  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
  has_one :refund

  scope :active, lambda {
    with_balance.not_expired
  }

  scope :with_balance, lambda {
    where('balance > 0')
  }

  scope :not_expired, lambda {
    where(expiration_date: nil)
      .or(CustomerCredit.where('expiration_date >= current_timestamp'))
  }
end
