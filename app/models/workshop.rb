# frozen_string_literal: true

# Customers purhcase tickets to Workshops to build Projects
class Workshop < ApplicationRecord
  include ApplicationHelper

  audited
  has_many_attached :images
  has_many :project_workshops
  has_many :projects, through: :project_workshops
  has_many :tickets
  has_many :customers, through: :tickets

  scope :upcoming, -> { where(is_for_sale: true) }
  scope :active, -> { upcoming.where('end_date >= CURRENT_TIMESTAMP') }

  validates_presence_of :name, :purchase_start_date, :purchase_end_date, :start_date,
                        :end_date, :is_for_sale

  def self.search(name, _sort = 'A')
    event = Workshop.active
    event = event.where('name like ?', "%#{name}%") unless name.blank?
    event
  end

  def tickets_available
    (is_private? ? Workshop.private_max : total_tickets) - tickets.count
  end

  def can_purchase?
    return false unless is_for_sale ||
                        tickets_available.positive? ||
                        (purchase_start_date <= Date.today && purchase_end_date >= Date.today) ||
                        projects.count.positive?

    true
  end

  def self.private_min
    12
  end

  def self.private_max
    24
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
    date_out(purhcase_start_date, purchase_end_date)
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
