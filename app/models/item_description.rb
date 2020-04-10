# frozen_string_literal: true

class ItemDescription < ApplicationRecord
  include Cancelable
  include Refundable
  include Taxable
  include Voidable

  has_paper_trail
  has_many :carts, inverse_of: :description
  has_many :invoice_items, inverse_of: :description
  has_many :seats, inverse_of: :description
  has_many :reservations, inverse_of: :description

  ITEM_TYPES = %i[seat reservation gift_card].freeze

  def self.seat(workshop)
    new(item_type: :seat,
        identifier: SecureRandom.uuid,
        workshop_name: workshop.name,
        workshop_id: workshop.id)
  end

  def self.reservation(workshop)
    new(item_type: :reservation,
        identifier: SecureRandom.uuid,
        workshop_name: workshop.name,
        workshop_id: workshop.id)
  end

  def self.gift_card(params)
    new(item_type: :gift_card,
        identifier: SecureRandom.uuid,
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: params[:email])
  end

  def ==(other)
    identifier == other.identifier
  end

  def title
    if reservation? && reservation&.host.present?
      "#{reservation.host.full_name.pluralize} #{workshop_name}"
    elsif reservation?
      "Reservation for #{workshop_name}"
    # elsif seat?
    #   "Seat to #{workshop_name}"
    # elsif gifted_seat?
    #   ''
    elsif gift_card?
      'Gift Card'
    else
      workshop_name
    end
  end

  def workshop
    @workshop ||= Workshop.find workshop_id
  end

  def invoice
    @invoice ||= invoice_items.any? ? invoice_items.first.invoice : nil
  end

  def reservation
    @reservation ||= reservations.any? ? reservations.first : nil
  end

  def seat
    @seat ||= seats.any? ? seats.first : nil
  end

  def item_amount
    @item_amount ||= (taxable_amount + nontaxable_amount).round(2)
  end

  def line_total
    @line_total ||= (item_amount + tax_amount).round(2)
  end

  def confirmation_number
    @confirmation_number ||= "#{id}#{identifier.split('-').first.upcase}"
  end

  def active?
    !voided? && !canceled?
  end

  def selection_made?
    project_name.present?
  end

  def recipient
    @recipient ||= User.find_by_email(email)
  end

  ITEM_TYPES.each do |type|
    define_method "#{type}?" do
      item_type == type.to_s
    end
  end

  def gifted_seat?
    seat? && gifted?
  end

  def reservation_seat?
    seat? && seat.present? && seat.reservation.present?
  end

  def in_cart?
    carts.any?
  end
end
