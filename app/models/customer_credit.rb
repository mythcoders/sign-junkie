class CustomerCredit < ApplicationRecord
  GIFT_CARD_AMOUNTS = [25,50,75,100]

  belongs_to :user
  has_one :refund
end
