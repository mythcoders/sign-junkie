# frozen_string_literal: true

##
# Handles complex operations for the Cart model
class CartService < ApplicationService
  # Adds a new item to the users cart
  #
  # @return [Boolean] result of +.save+
  def add(user, cart_params)
    return pay_for_reservation(user, cart_params) if cart_params[:reservation_id]
    return pay_for_seat(user, cart_params) if cart_params[:seat_id]

    cart = if cart_params[:type] == 'gift_card'
             new_gift_card(user, cart_params)
           else
             add_item user, cart_params
           end
    cart.save
  end

  # Adds the requested seat to the users cart
  #
  # @return [Boolean] result of +.save+
  def pay_for_seat(user, cart_params)
    seat = Seat.find cart_params[:seat_id]

    new_from_seat(user, seat).save
  end

  # Adds all unpaid seats for the requested reservation to the users cart
  #
  # @return [Boolean]
  def pay_for_reservation(user, cart_params)
    reservation = Reservation.find cart_params[:reservation_id]

    reservation.unpaid_seats.each do |seat|
      new_from_seat(user, seat).save
    end

    true
  end

  def remove(user, cart_params)
    cart = Cart.find(cart_params[:id])
    return false if user.id != cart.user_id

    cart.delete
  end

  def empty!(user, as_of = Time.zone.now)
    Cart.for(user).as_of(as_of).delete_all
  end

  private

  def add_item(user, cart_params)
    workshop = Workshop.includes(:projects).find(cart_params[:workshop_id])

    if cart_params[:type] == 'reservation'
      raise ProcessError, 'Workshop is not available for purchase' unless workshop.reservation_purchaseable?

      agreements = %i[booking_agreement reservation_agreement]
      raise ProcessError, 'Please select all reservation confirmations' unless agreements_checked(cart_params, agreements)

      new_reservation user, workshop, cart_params
    else
      raise ProcessError, 'Workshop is not available for purchase' unless workshop.seat_purchaseable?

      agreements = %i[design_confirmation policy_agreement acknowledgment]
      raise ProcessError, 'Please select all confirmations' unless agreements_checked(cart_params, agreements)
      raise ProcessError, 'No project selected' unless cart_params[:project_id].present?

      new_seat user, workshop, cart_params
    end
  end

  def new_seat(user, workshop, params)
    project = workshop.projects.where(id: params[:project_id]).first!
    cart = Cart.new(user: user,
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

  def new_gift_card(user, params)
    Cart.new(user: user,
             description: ItemDescription.gift_card(params),
             nontaxable_amount: params[:amount],
             taxable_amount: 0.00)
  end

  def new_reservation(user, workshop, params)
    Cart.new(user: user,
             description: ItemDescription.reservation(workshop),
             payment_plan: params[:payment_plan],
             nontaxable_amount: workshop.reservation_price,
             taxable_amount: 0.00)
  end

  def new_from_seat(user, seat)
    Cart.new(user: user,
             item_description_id: seat.item_description_id)
  end

  def agreements_checked(values, agreements)
    agreements.all? { |key| values[key] == '1' }
  end
end
