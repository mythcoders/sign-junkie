class Customer < ApplicationRecord
  has_many :addresses
  has_many :orders
  has_many :notes
  has_many :cart_items
end
