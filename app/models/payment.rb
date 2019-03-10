class Payment < ApplicationRecord
  belongs_to :invoice
end
