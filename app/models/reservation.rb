# frozen_string_literal: true

class Reservation < ApplicationRecord
  has_paper_trail
  has_many :seats
  belongs_to :workshop
  belongs_to :host, class_name: 'User', foreign_key: 'user_id'
  belongs_to :description, class_name: 'ItemDescription', foreign_key: 'item_description_id'
  delegate_missing_to :description
  accepts_nested_attributes_for :description

  scope :active, -> { includes(:description).where(item_descriptions: { void_date: nil, cancel_date: nil }) }
  scope :for_user, ->(user) { where(user_id: user.id).order(:id) unless user.nil? }
  scope :paid_by_guest, -> { includes(:description).where(item_descriptions: { payment_plan: 'guest' }) }
  scope :for_shop, ->(id) { where(workshop_id: id) }
  scope :paid_by_host, -> { includes(:description).where(item_descriptions: { payment_plan: 'host' }) }
  scope :attending, ->(user_id) { joins(:seats).where(seats: { user_id: user_id }) }
  scope :hosting, ->(user_id) { where(user_id: user_id) }
  scope :attending_or_hosting, lambda { |user_id|
    left_outer_joins(:seats)
      .where('reservations.user_id = :user_id OR seats.user_id = :user_id', user_id: user_id)
      .distinct
  }

  def may_add_seat?(user)
    host?(user) && can_add_seat?
  end

  def can_add_seat?
    active? && active_seats.count <= maximum_seats && Time.zone.now < workshop.registration_deadline
  end

  def payment_deadline
    (workshop.start_date - (paid_by_host? ? 5.days : 7.days)).beginning_of_day
  end

  def minimum_seats
    workshop.reservation_minimum_seats
  end

  def maximum_seats
    workshop.reservation_maximum_seats
  end

  def host?(user)
    user.id == host.id
  end

  def paid_by_host?
    payment_plan == 'host'
  end

  def requirements_met?
    paid_seats >= minimum_seats
  end

  def remaining_seats_until_requirements_met
    minimum_seats - active_seats.count
  end

  def balance
    (unpaid_seats.map(&:line_total).reduce(:+) || 0.00).round(2)
  end

  def unpaid_balance?
    balance.positive?
  end

  def unpaid_seats
    seats.select(&:unpaid?)
  end

  def active_seats
    seats.select(&:active?)
  end

  def paid_seats
    seats.select(&:paid?)
  end
end
