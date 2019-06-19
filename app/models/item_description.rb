class ItemDescription < ApplicationRecord
  include Refundable
  include Taxable

  has_paper_trail
  has_many :carts
  has_many :invoice_items
  has_many :seats

  ITEM_TYPES = %i[seat reservation gift_card]

  def self.seat(workshop)
    self.new(item_type: :seat,
             identifier: SecureRandom.uuid,
             workshop_name: workshop.name,
             workshop_id: workshop.id)
  end

  def self.reservation(workshop)
    self.new(item_type: :reservation,
             identifier: SecureRandom.uuid,
             workshop_name: workshop.name,
             workshop_id: workshop.id)
  end

  def self.gift_card(params)
    self.new(item_type: :gift_card,
             identifier: SecureRandom.uuid,
             first_name: params[:first_name],
             last_name: params[:last_name],
             email: params[:email])
  end

  def ==(other)
    return self.identifier == other.identifier
  end

  def title
    if reservation?
      "Reservation for #{workshop_name}"
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
      self.item_type == "#{type}"
    end
  end
end

