# frozen_string_literal: true

# Tickets for Events are purchased by customers
class Event < ApplicationRecord
  audited
  has_many_attached :images

  scope :active, (lambda do
    where('is_for_sale = ? AND posting_start_date <= CURRENT_TIMESTAMP AND end_date >= CURRENT_TIMESTAMP', true)
    .distinct
  end)

  validates_presence_of :name, :posting_start_date, :start_date, :is_for_sale
  # validates_length_of :description

  def self.search(name, _sort = 'A')
    event = Event.active
    event = event.where('name like ?', "%#{name}%") unless name.blank?
    event
  end

  def can_purchase?
    return false unless is_for_sale ||
                        tickets_available.positive? ||
                        posting_start_date <= Date.today

    true
  end

  def primary_image_attachment_id
    primary_image.id
  end

  def primary_image
    images.order(:id).first if images.any?
  end

  def when
    if start_date.day == end_date.day
      "#{start_date.strftime('%b %d, %Y %I:%M %p')} - #{end_date.strftime('%I:%M %p')}"
    else
      "#{start_date.strftime('%b %d, %Y %I:%M %p')} - #{end_date.strftime('%b %d, %Y %I:%M %p')}"
    end
  end

  def add_stock(amount, _user_id)
    self.tickets_available += amount
    save
  end

  def return_stock(amount)
    self.tickets_available += amount
    save
  end

  def remove_stock(amount)
    self.tickets_available -= amount
    save
  end
end
