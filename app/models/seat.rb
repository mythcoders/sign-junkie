class Seat < ApplicationRecord
  belongs_to :reservation, optional: true
  belongs_to :invoice, optional: true
  belongs_to :user
  belongs_to :workshop
end
