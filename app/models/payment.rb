class Payment < ApplicationRecord
  audited
  belongs_to :order
end
