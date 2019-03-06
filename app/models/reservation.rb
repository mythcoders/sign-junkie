class Reservation < ApplicationRecord
  has_many :seats
  belongs_to :user
end
