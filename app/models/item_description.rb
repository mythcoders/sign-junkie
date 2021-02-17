# frozen_string_literal: true

class ItemDescription < ApplicationRecord
  include Cancelable
  include Refundable
  include Taxable
  include Voidable

  has_paper_trail
  has_one :cart, inverse_of: :description, dependent: :destroy
  has_one :invoice_item, inverse_of: :description
  has_one :seat, inverse_of: :description
  has_one :reservation, inverse_of: :description

  delegate :invoice, to: :invoice_item, allow_nil: true

  ITEM_TYPES = %i[seat reservation gift_card].freeze
  ITEM_TYPES.each do |type|
    define_method "#{type}?" do
      item_type == type.to_s
    end
  end

  # This allows the field to be set as a Hash or anything compatible with it.
  serialize :owner, JsonHashieMash
  def owner=(new_value)
    self[:owner] = JsonHashieMash.new new_value
  end

  def ==(other)
    identifier == other.identifier
  end

  def title
    if reservation? && reservation&.host.present?
      "#{reservation.host.full_name.pluralize} #{workshop_name}"
    elsif reservation?
      "Reservation for #{workshop_name}"
    elsif gift_card?
      'Gift Card'
    else
      workshop_name
    end
  end

  def guest_name
    @guest_name ||= gifted_seat? ? "#{owner.first_name} #{owner.last_name}" : nil
  end

  def guest_name_initials
    guest_name.split.map(&:first).join.upcase
  end

  def workshop
    @workshop ||= Workshop.find workshop_id
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

  def gifted_seat?
    seat? && gifted?
  end

  def reservation_seat?
    seat? && seat.present? && seat.reservation.present?
  end

  def in_cart?
    cart.present? # && cart.persisted?
  end

  def unpaid?
    invoice.nil? && selection_made?
  end

  def paid?
    invoice.present?
  end

  def guest_type
    # this check accomidates records created before v2102
    # In prior releases, the seat customer was the owner if no other owner was explicitily set
    owner.nil? || owner.empty? ? 'self' : owner.type
  end
end
