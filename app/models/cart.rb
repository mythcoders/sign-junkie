# frozen_string_literal: true

class Cart < ApplicationRecord
  has_paper_trail
  belongs_to :customer, class_name: 'User', foreign_key: 'user_id'
  belongs_to :description, class_name: 'ItemDescription', foreign_key: 'item_description_id', dependent: :destroy

  scope :for, ->(user) { where(user_id: user.id).order(:id) unless user.nil? }
  scope :as_of, ->(date_created) { where('created_at <= ?', date_created) }
  scope :for_shop, ->(id) { includes(:description).where(item_descriptions: { workshop_id: id }) }
  scope :seats, -> { includes(:description).where(item_descriptions: { item_type: 'seat' }) }
  scope :reservations, -> { includes(:description).where(item_descriptions: { item_type: 'reservation' }) }
  scope :non_gift_seat, -> { seats.where(item_descriptions: { gifted: false }) }

  delegate_missing_to :description
  validate :validate_can_book, on: :create

  def self.empty!(user, as_of = Time.zone.now)
    Cart.for(user).as_of(as_of).delete_all
  end

  def self.remove!(user, id)
    cart = Cart.find id
    return false if user.id != cart.user_id

    cart.delete
  end

  private

  def validate_can_book
    if seat?
      SeatService::BookableValidation.perform(description, customer)
    elsif reservation?
      ReservationService::BookableValidation.perform(description, customer)
    end
  rescue ProcessError => e
    errors.add(:base, e.message)
  end
end
