class OrderNote < ApplicationRecord
  audited
  belongs_to :order
end
