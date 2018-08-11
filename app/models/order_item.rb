class OrderItem < ApplicationRecord
  audited
  belongs_to :order
end
