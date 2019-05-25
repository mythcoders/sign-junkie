class Workshop < ApplicationRecord
  include ApplicationHelper

  has_paper_trail
  has_many :workshop_projects, :dependent => :destroy
  has_many :projects, through: :workshop_projects
  has_many :seats
  has_many_attached :workshop_images, :dependent => :destroy

  accepts_nested_attributes_for :projects

  scope :public_shops, -> { where(is_public: true) }
  scope :private_shops, -> { where(is_public: false) }
  scope :for_sale, -> { where(is_for_sale: true) }
  scope :upcoming, -> { for_sale.where('purchase_start_date <= CURRENT_TIMESTAMP AND
                                        purchase_end_date >= CURRENT_TIMESTAMP')}

  validates_presence_of :name

  # Searches workshops on a variety of factors
  # @return [Array] returns of the search
  def self.search(name, _sort = 'A')
    results = Workshop.upcoming
    results = event.where('name like ?', "%#{name}%") unless name.blank?
    results
  end

  def starting_price
    10.00
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
    BigDecimal.new("100.00")
  end

  # Time period
  # @return [Time]
  def self.booking_deadline
    48.hours
  end

  def images
    workshop_images # + project_images
  end

  def project_images
    projects
      .collect(&:project_images)
      .select(&:attached?)
      .collect(&:attachments)
  end

  def can_purchase?
    return false unless seats_available.positive?
    return false unless is_for_sale ||
                        (purchase_start_date <= Date.today && purchase_end_date >= Date.today) ||
                        projects.count.positive?

    true
  end

  def seats_available
    (is_private? ? Workshop.private_max : total_tickets) - seats.count
  end

  def display
    "#{start_date.strftime('%B %d, %I:%M %p')} #{name}"
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

  def cancel_by_date
    (start_date - Workshop.booking_deadline)
  end

  def is_private?
    !is_public?
  end

  def deleteable?
    return false if seats.any?

    true
  end
end
