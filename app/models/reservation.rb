class Reservation < ApplicationRecord
  has_many :seats
  belongs_to :host, class_name: 'User', foreign_key: 'user_id'
end
