class Refund < ApplicationRecord
  has_paper_trail
  belongs_to :invoice
  belongs_to :refund_reason
end
