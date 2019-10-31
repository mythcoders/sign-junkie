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
  scope :non_gift_seat, -> { seats.where(item_descriptions: { email: nil }) }
  scope :gifted_seats, ->(email) { seats.where(item_descriptions: { email: email }) }

  delegate_missing_to :description
  validate :validate_can_book, on: :create

  def self.new_seat(user, workshop, params)
    project = workshop.projects.where(id: params[:project_id]).first!
    cart = new(user: user,
               description: ItemDescription.seat(workshop),
               project_id: project.id,
               project_name: project.name,
               taxable_amount: project.material_price,
               nontaxable_amount: project.instructional_price)

    cart.seat_preference = params[:seating] if params[:seating].present?

    if params[:stencil_id].present?
      stencil = project.stencils.where(id: params[:stencil_id]).first!
      cart.stencil_id = stencil.id
      cart.stencil_name = stencil.name
      cart.stencil_personalization = params[:stencil] if params[:stencil].present?
    else
      cart.stencil_name = I18n.translate('seat.no_stencil')
    end

    if params[:addon_id].present?
      addon = project.addons.where(id: params[:addon_id]).first
      cart.addon_id = addon.id
      cart.addon_name = addon.name
      cart.taxable_amount += addon.price
    end

    if params[:email].present?
      cart.email = params[:email]
      cart.first_name = params[:first_name]
      cart.last_name = params[:last_name]
    end

    cart
  end

  def self.new_gift_card(user, params)
    new(user: user,
        description: ItemDescription.gift_card(params),
        nontaxable_amount: params[:amount],
        taxable_amount: 0.00)
  end

  def self.new_reservation(user, workshop, params)
    new(user: user,
        description: ItemDescription.reservation(workshop),
        payment_plan: params[:payment_plan],
        nontaxable_amount: workshop.reservation_price,
        taxable_amount: 0.00)
  end

  def self.new_from_seat(user, seat)
    new(user: user,
        item_description_id: seat.item_description_id)
  end

  private

  def seat_owner
    @seat_owner ||= gifted_seat? ? User.find_or_initialize_by(email: email) : user
  end

  # TODO: AP-241 Move this to CartService
  def validate_can_book
    if seat?
      # raise ProcessError, 'Workshop is not accepting anymore seats' unless workshop.seat_purchaseable?
      raise ProcessError, 'This seat has already been added to someones cart' unless description.carts.none?

      existing_seats = SeatService.already_booked?(seat_owner, workshop_id)
      existing_cart_items = Cart.for(seat_owner).for_shop(workshop_id).non_gift_seat.any?
      existing_gifts = Cart.gifted_seats(seat_owner.email).any?

      if existing_cart_items || existing_seats || existing_gifts
        raise ProcessError, 'Seat to this workshop has already been booked or added to cart'
      end

      return if description.seats.any?
    elsif reservation?
      # raise ProcessError, 'Workshop is not accepting anymore reservations' unless workshop.reservation_purchaseable?
      raise ProcessError, 'This reservation has already been added to someones cart' unless description.carts.none?

      existing_reservation = ReservationService.already_booked?(seat_owner, workshop_id)
      existing_seats = SeatService.already_booked?(seat_owner, workshop_id)
      existing_cart_items = Cart.for(seat_owner).for_shop(workshop_id).reservations.any?

      if existing_reservation || existing_seats || existing_cart_items
        raise ProcessError, 'Reservation has already been booked or added to cart'
      end
    end
  end
end
