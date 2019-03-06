# frozen_string_literal: true

# Customers purhcase tickets to Workshops to build Projects
class Workshop < ApplicationRecord
  include ApplicationHelper

  audited
  has_many_attached :images
  has_many :project_workshops
  has_many :projects, through: :project_workshops
  has_many :designs, through: :projects
  has_many :addons, through: :projects
  has_many :tickets, -> { where(for_deposit: false) }, class_name: 'OrderItem'

  scope :upcoming, -> { where(is_for_sale: true) }
  scope :active, -> { upcoming.where('end_date >= CURRENT_TIMESTAMP') }

  validates_presence_of :name, :purchase_start_date, :purchase_end_date, :start_date,
                        :end_date, :is_for_sale

  def self.search(name, _sort = 'A')
    event = Workshop.active
    event = event.where('name like ?', "%#{name}%") unless name.blank?
    event
  end

  # Tickets that are still available for purchase
  # @return [Integer] number of tickets
  def tickets_available
    (is_private? ? Workshop.private_max : total_tickets) - tickets.count
  end

  # Wether tickets to the workshop are available for purchase
  # @return [Boolean] True if the workshop can be purchased, otherwise false
  def can_purchase?
    return false unless is_for_sale ||
                        tickets_available.positive? ||
                        (purchase_start_date <= Date.today && purchase_end_date >= Date.today) ||
                        projects.select { |p| p.addons.count.positive?  }.count.positive?

    true
  end

  # Minimum seats for a private workshop
  # @return [Integer] number of seats
  def self.private_min
    12
  end

  # Maximum seats for a private workshop
  # @return [Integer] number of seats
  def self.private_max
    24
  end

  # Deposit for private workshops
  # @return [Integer] USD amount
  def self.private_deposit
    100
  end

  # Time period
  # @return [Time]
  def self.booking_deadline
    48.hours
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
    date_out(purchase_start_date, purchase_end_date)
  end

  def book_by_date
    (start_date - Workshop.booking_deadline).beginning_of_day
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
    purchase_start_date > start_date || purchase_end_date > start_date
  end
end
