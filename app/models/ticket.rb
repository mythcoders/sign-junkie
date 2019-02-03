class Ticket < ApplicationRecord
  belongs_to :customer, required: false
  belongs_to :project, required: false
  belongs_to :addon, required: false
  belongs_to :workshop
  belongs_to :order_item

  validates_presence_of :identifier, :workshop
end
