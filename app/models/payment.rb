class Payment < ApplicationRecord
  has_paper_trail
  belongs_to :invoice
  attr_accessor :auth_token
end
