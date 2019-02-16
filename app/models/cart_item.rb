class CartItem < ApplicationRecord
  audited

  scope :for, ->(user) { where(user_id: user.id).order(:id) unless user.nil? }
  scope :as_of, -> { where('created_at <= CURRENT_TIMESTAMP') }
  scope :as_of, ->(date_created) { where('created_at <= ?', date_created) unless date_created.nil? }

  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
  belongs_to :workshop
  belongs_to :addon, required: false
  belongs_to :project, required: false
  belongs_to :design, required: false

  validates_presence_of :workshop_id, :user_id, :price

  def amount
    workshop.ticket_price * quantity
  end

  def display
    val = workshop.name
    val << " - #{project.name}" if project_id.present?
    val << " (#{customization})" if customization.present?
    val << " w/ #{addon.name}" if addon_id.present?
    val
  end
end
