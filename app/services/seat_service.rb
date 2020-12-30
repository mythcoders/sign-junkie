# frozen_string_literal: true

class SeatService < ApplicationService
  class << self
    def create(reservation)
      Seat.new(reservation: reservation,
               workshop: reservation.workshop,
               description: SeatItemFactory.build(reservation.workshop, {}))
    end

    def already_booked?(seat_owner, seat)
      if seat.gifted_seat? && seat.email.present?
        Seat.for_user(seat.recipient).for_shop(seat.workshop_id).active.select(&:paid?).any?
      elsif seat.gifted_seat?
        Seat.for_shop(seat.workshop_id).active
            .select { |s| s.first_name == seat.first_name && s.last_name == seat.last_name && s.paid? }.any?
      else
        Seat.for_user(seat_owner).for_shop(seat.workshop_id).active.select(&:paid?).any?
      end
    end
  end

  # Create seat in the context of processing the invoice
  def reserve(invoice_item, _purchaser)
    return if invoice_item.description.seats.any?

    recipient = if invoice_item.gifted_seat? && invoice_item.email.present?
                  CustomerService.find_or_invite(invoice_item.first_name, invoice_item.last_name, invoice_item.email)
                else
                  invoice_item.invoice.customer
                end
    Seat.create!(
      item_description_id: invoice_item.description.id,
      workshop_id: invoice_item.workshop_id,
      prepped: false,
      notified: false,
      customer: recipient
    )
  end

  def add(params, purchaser)
    seat = if params[:guest_type] == 'child'
             seat_for_child params
           elsif params[:guest_type] == 'guest'
             seat_for_guest params, purchaser
           else
             seat_for_adult params
           end
    return false unless seat.valid? && seat.save!

    SeatMailer.with(seat_id: seat.id).invited.deliver_later
    true
  end

  def update(seat, params)
    seat.description = SeatItemFactory.build(seat.workshop, params)
    seat.save!
  end

  def cancel(seat)
    seat.cancel_date = Time.zone.now
    return false unless seat.valid? && seat.save!

    RefundWorker.perform_async(seat.item_description_id) if seat.refundable?
    true
  end

  def void(seat)
    seat.void_date = Time.zone.now
    return false unless seat.valid? && seat.save!

    RefundWorker.perform_async(seat.item_description_id) if seat.refundable?
    true
  end

  private

  def update_addon(seat, project, params)
    addon = project.addons.where(id: params[:addon_id]).first
    seat.addon_id = addon.id
    seat.addon_name = addon.name
    seat.taxable_amount += addon.price
  end

  def seat_for_adult(params)
    seat = SeatService.create(params[:reservation])
    seat.customer = CustomerService.find_or_invite(params[:first_name], params[:last_name], params[:email])
    seat
  end

  def seat_for_child(params)
    seat = seat_for_adult params
    seat.for_child = true
    seat.first_name = params[:child_first_name]
    seat.last_name = params[:child_last_name]
    seat
  end

  def seat_for_guest(params, purchaser)
    seat = SeatService.create(params[:reservation])
    seat.customer = purchaser
    seat.gifted = true
    seat.first_name = params[:child_first_name]
    seat.last_name = params[:child_last_name]
    seat
  end
end
