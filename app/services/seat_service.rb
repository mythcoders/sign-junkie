# frozen_string_literal: true

class SeatService < ApplicationService
  class << self
    def create(reservation)
      Seat.new(reservation: reservation,
               workshop: reservation.workshop,
               description: ItemDescription.seat(reservation.workshop))
    end

    def already_booked?(user, workshop_id)
      Seat.for_user(user).for_shop(workshop_id).active.select(&:paid?).any?
    end
  end

  def reserve(invoice_item, _user = nil)
    return if invoice_item.description.seats.any?

    recipient = invoice_item.gifted_seat? ? invoice_item.recipient : invoice_item.invoice.customer
    Seat.create!(
      item_description_id: invoice_item.description.id,
      workshop_id: invoice_item.workshop_id,
      prepped: false,
      notified: false,
      customer: recipient
    )
  end

  def add(params)
    seat = SeatService.create(params[:reservation])
    seat.customer = CustomerService.find_or_invite(params[:first_name], params[:last_name], params[:email])
    seat.tax_amount = 0.00
    seat.taxable_amount = 0.00
    seat.nontaxable_amount = 0.00
    return false unless seat.valid? && seat.save!

    SeatMailer.with(seat: seat).invited.deliver_now
    true
  end

  def update(seat, params)
    project = seat.workshop.projects.where(id: params[:project_id]).first!
    seat.project_id = project.id
    seat.project_name = project.name
    seat.taxable_amount = project.material_price
    seat.nontaxable_amount = project.instructional_price
    seat.seat_preference = params[:seating] if params[:seating].present?

    if params[:stencil_id].present?
      stencil = project.stencils.where(id: params[:stencil_id]).first!
      seat.stencil_id = stencil.id
      seat.stencil_name = stencil.name
      seat.stencil_personalization = params[:stencil] if params[:stencil].present?
    else
      seat.stencil_name = I18n.translate('seat.no_stencil')
    end

    update_addon(seat, project, params) if params[:addon_id].present?

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
end
