class CustomerCredit < ApplicationRecord
  belongs_to :user
  has_one :refund
end
