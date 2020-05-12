# frozen_string_literal: true

class Cart < ApplicationRecord
  has_paper_trail
  belongs_to :user
  belongs_to :description, class_name: 'ItemDescription', foreign_key: 'item_description_id', dependent: :destroy

  scope :for, ->(user) { where(user_id: user.id).order(:id) unless user.nil? }
  scope :as_of, ->(date_created) { where('created_at <= ?', date_created) }
  scope :for_shop, ->(id) { includes(:description).where(item_descriptions: { workshop_id: id }) }
  scope :seats, -> { includes(:description).where(item_descriptions: { item_type: 'seat' }) }
  scope :reservations, -> { includes(:description).where(item_descriptions: { item_type: 'reservation' }) }
  scope :non_gift_seat, -> { seats.where(item_descriptions: { gifted: false }) }
  scope :gifted_seats, ->(email) { seats.where(item_descriptions: { email: email, gifted: true }) }

  delegate_missing_to :description
  validate :validate_can_book, on: :create

  private

  def seat_owner
    @seat_owner ||= gifted_seat? && email.present? ? User.find_or_initialize_by(email: email) : user
  end

  # TODO: AP-241 Move this to CartService
  def validate_can_book
    if gifted_seat?
      raise ProcessError, 'This seat has already been added to someones cart' unless description.carts.none?

      existing_cart_items = if email.present?
                              Cart.seats.for_shop(workshop_id)
                                  .where('trim(item_descriptions.email) = ?', seat_owner.email).any?
                            else
                              binding.pry
                              Cart.seats.for_shop(workshop_id)
                                  .where('trim(item_descriptions.first_name) = ?', first_name)
                                  .where('trim(item_descriptions.last_name) = ?', last_name).any?
                            end
      existing_seats = SeatService.already_booked?(nil, self)

      if existing_cart_items || existing_seats
        raise ProcessError, 'That guest already has a seat for this workshop booked or added to a cart'
      end
    elsif seat?
      raise ProcessError, 'Workshop is not accepting anymore seats' if !workshop.seat_purchaseable? && !seat.persisted?
      raise ProcessError, 'This seat has already been added to someones cart' unless description.carts.none?

      existing_cart_items = Cart.for(seat_owner).for_shop(workshop_id).non_gift_seat.any?

      if existing_cart_items || existing_seats || existing_gifts
        raise ProcessError, 'Seat to this workshop has already been booked or added to cart'
      end

      return if description.seats.any?
    elsif reservation?
      raise ProcessError, 'Workshop is not accepting anymore reservations' unless workshop.reservation_purchaseable?
      raise ProcessError, 'This reservation has already been added to someones cart' unless description.carts.none?

      existing_cart_items = Cart.for(seat_owner).for_shop(workshop_id).reservations.any?

      if existing_reservation || existing_seats || existing_cart_items
        raise ProcessError, 'Reservation has already been booked or added to cart'
      end
    end
  end

  def existing_seats
    @existing_seats ||= SeatService.already_booked?(seat_owner, self)
  end

  def existing_reservation
    @existing_reservation ||= ReservationService.already_booked?(seat_owner, workshop_id)
  end

  def existing_gifts
    @existing_gifts ||= Cart.gifted_seats(seat_owner.email).any?
  end
end
