class CartItem < ApplicationRecord
  audited

  scope :for, ->(user) { where(user_id: user.id).order(:id) unless user.nil? }
  scope :as_of, -> { where('created_at <= CURRENT_TIMESTAMP') }
  scope :as_of, ->(date_created) { where('created_at <= ?', date_created) unless date_created.nil? }

  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
  belongs_to :workshop
  belongs_to :addon
  belongs_to :project, required: false

  validates_presence_of :workshop_id, :user_id

  def amount
    workshop.ticket_price * quantity
  end

  def display
    value = workshop.name
    value << " - #{project.name}" if project_id.present?
    value << " w/ #{addon.name}" if addon_id.present?
    value
  end
end
