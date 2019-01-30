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
    where(is_for_sale: true)
      .where('posting_start_date <= CURRENT_TIMESTAMP AND posting_end_date >= CURRENT_TIMESTAMP')
      .distinct
  end)

  validates_presence_of :name, :posting_start_date, :start_date, :end_date, :is_for_sale

  def self.search(name, _sort = 'A')
    event = Workshop.active
    event = event.where('name like ?', "%#{name}%") unless name.blank?
    event
  end

  def tickets_available
    total_tickets - attendees.count
  end

  def can_purchase?
    return false unless is_for_sale ||
                        tickets_available.positive? ||
                        (posting_start_date <= Date.today && posting_end_date >= Date.today) ||
                        projects.count.positive?

    true
  end

  def self.private_min
    12
  end

  def self.private_max
    18
  end

  def self.private_deposit
    100
  end

  def is_private?
    !is_public?
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

  private

  def check
    if end_date_before_start || posting_during_event

    end
  end

  def end_date_before_start
    end_date > start_date
  end

  def posting_during_event
    posting_start_date > start_date || posting_end_date > start_date
  end
end
