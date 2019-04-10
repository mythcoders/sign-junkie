class Cart < ApplicationRecord
  audited
  belongs_to :user
  scope :for, ->(user) { where(user_id: user.id).order(:id) unless user.nil? }
  scope :as_of, -> { where('created_at <= CURRENT_TIMESTAMP') }
  scope :as_of, ->(date_created) { where('created_at <= ?', date_created) }

  serialize :description, ItemDescription
  delegate_missing_to :description

  def total
    price * quantity
  end
end

