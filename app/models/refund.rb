class Refund < ApplicationRecord
  belongs_to :invoice
  belongs_to :refund_reason
end
