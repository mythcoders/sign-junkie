class CustomerCredit < ApplicationRecord
  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
end
