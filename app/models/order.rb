class Order < ApplicationRecord
  audited
  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
  has_many :items, class_name: 'OrderItem'
  has_many :notes, class_name: 'OrderNote'
  has_many :payments
end
