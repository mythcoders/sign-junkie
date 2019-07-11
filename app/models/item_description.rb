# frozen_string_literal: true

class ItemDescription < ApplicationRecord
  include Refundable
  include Taxable

  has_paper_trail
  has_many :carts
  has_many :invoice_items
  has_many :seats

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
    if reservation?
      "Reservation for #{workshop_name}"
    # elsif gifted_seat?
    #   "#{workshop_name} for #{item.first_name} #{item.last_name}"
    elsif gift_card?
      'Gift Card'
    else
      workshop_name
    end
  end

  def workshop
    @workshop ||= Workshop.find workshop_id
  end

  def item_amount
    (taxable_amount + nontaxable_amount).round(2)
  end

  def line_total
    (item_amount + tax_amount).round(2)
  end

  def gifted_seat?
    seat? && email.present?
  end

  ITEM_TYPES.each do |type|
    define_method "#{type}?" do
      item_type == type.to_s
    end
  end
end
