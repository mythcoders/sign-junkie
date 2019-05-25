class Seat < ApplicationRecord
  has_paper_trail
  belongs_to :reservation, optional: true
  belongs_to :invoice, optional: true
  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
  belongs_to :workshop

  serialize :description, ItemDescription
end
