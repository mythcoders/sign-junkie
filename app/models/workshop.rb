class Workshop < ApplicationRecord
  has_many :projects
  has_many :seats

  scope :for_sale, -> { where(is_for_sale: true) }
  scope :upcoming, -> { for_sale.where('start_date >= CURRENT_TIMESTAMP') }

  validates_presence_of :name, :is_for_sale, :is_public, :allow_custom_projects

    # Searches workshops on a variety of factors
  # @return [Array] returns of the search
  def self.search(name, _sort = 'A')
    results = Workshop.upcoming
    results = event.where('name like ?', "%#{name}%") unless name.blank?
    results
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

  def seats_available
    (is_private? ? Workshop.private_max : total_tickets) - seats.count
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

  def is_private?
    !is_public?
  end
end
