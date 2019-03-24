class Payment < ApplicationRecord
  belongs_to :invoice
  attr_accessor :auth_token
end
