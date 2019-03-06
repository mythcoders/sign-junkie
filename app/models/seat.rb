class Seat < ApplicationRecord
  belongs_to :reservation, optional: true
  belongs_to :user
  belongs_to :invoice
  belongs_to :workshop
end
