class CustomerCredit < ApplicationRecord
  belongs_to :user
  has_one :refund

  scope :active, lambda {
    where(expiration_date: nil)
      .or(CustomerCredit.where('expiration_date >= current_timestamp'))
  }
end
