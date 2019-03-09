class Cart < ApplicationRecord
  audited

  scope :for, ->(user) { where(user_id: user.id).order(:id) unless user.nil? }
  scope :as_of, -> { where('created_at <= CURRENT_TIMESTAMP') }
  scope :as_of, ->(date_created) { where('created_at <= ?', date_created) unless date_created.nil? }

  serialize :item, ItemDescription

  def self.build(user, params)
    return if params[:workshop].nil?

    cart = Cart.new(user_id: user.id, quantity: params[:quantity])
    cart.item = ItemDescription.new(params)
    cart
  end
end

