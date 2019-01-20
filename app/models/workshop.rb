# frozen_string_literal: true

# Tickets for Events are purchased by customers
class Workshop < ApplicationRecord
  include ApplicationHelper
  audited
  has_many_attached :images
  has_many :project_workshops
  has_many :projects, through: :project_workshops
  has_many :attendees

  scope :active, (lambda do
    where('is_for_sale = ? AND posting_start_date <= CURRENT_TIMESTAMP AND posting_end_date >= CURRENT_TIMESTAMP', true)
    .distinct
  end)

  validates_presence_of :name, :posting_start_date, :start_date, :is_for_sale

  def self.search(name, _sort = 'A')
    event = Workshop.active
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
    date_out(start_date, end_date)
  end

  def when_purchase
    date_out(posting_start_date, posting_end_date)
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
