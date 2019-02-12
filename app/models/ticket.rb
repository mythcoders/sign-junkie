class Ticket < ApplicationRecord
  belongs_to :customer, required: false
  belongs_to :project, required: false
  belongs_to :addon, required: false
  belongs_to :workshop
  belongs_to :order_item

  validates_presence_of :identifier, :workshop

  def display
    val = workshop.name
    val << " - #{project.name}" if project_id.present?
    val << " (#{customization})" if customization.present?
    val << " w/ #{addon.name}" if addon_id.present?
    val
  end

  def score
    value = 0
    value += 1 if project.present?
    value += 1 if customer.present?
    value += 1 if order_item.payments.any?
    value / 3
  end
end
