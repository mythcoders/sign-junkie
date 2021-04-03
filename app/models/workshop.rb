# frozen_string_literal: true

class Workshop < ApplicationRecord
  include ApplicationHelper
  include Workshopable

  has_paper_trail
  has_many :workshop_projects, dependent: :destroy
  has_many :projects, through: :workshop_projects
  has_many :seats, dependent: :restrict_with_error
  has_many :reservations, dependent: :restrict_with_error
  has_many_attached :workshop_images, dependent: :destroy
  has_rich_text :description
  belongs_to :workshop_type

  accepts_nested_attributes_for :projects

  scope :upcoming, -> { where('end_date <= CURRENT_TIMESTAMP') }
  scope :for_sale, lambda {
    where(is_for_sale: true)
      .where('purchase_start_date <= CURRENT_TIMESTAMP AND start_date >= CURRENT_TIMESTAMP')
  }

  validates_presence_of :name
  validates_length_of :name, maximum: 50
  validates_presence_of :purchase_start_date, :purchase_end_date, :start_date, :end_date, if: :is_for_sale
  validate :workshop_type_not_changed

  def self.clone(id)
    find(id).deep_clone include: [:workshop_projects], exclude: [:is_for_sale] do |original, kopy|
      if kopy.is_a?(Workshop) && original.workshop_images.any?
        kopy.name += ' copy'
        original.workshop_images.each do |image|
          kopy.workshop_images.attach(
            io: StringIO.new(image.download),
            filename: image.filename,
            content_type: image.content_type
          )
        end
      end
    end
  end

  def seat_purchaseable?
    return false unless is_for_sale &&
                        projects.count.positive? &&
                        Time.zone.now.between?(purchase_start_date, purchase_end_date) &&
                        single_seats_allowed? &&
                        seats_available.positive?

    true
  end

  def reservation_purchaseable?
    return false unless is_for_sale &&
                        projects.count.positive? &&
                        reservations_allowed? &&
                        Time.zone.now.between?(purchase_start_date, booking_deadline)
    return false if seats_available <= reservation_minimum_seats
    return false if reservations.any? && !multiple_reservations_allowed?

    true
  end

  def deleteable?
    seats.select(&:active?).none? && reservations.select(&:active?).none?
  end

  def name_with_date
    "#{start_date.strftime('%-m/%-d/%Y')} - #{name}"
  end

  private

  def workshop_type_not_changed
    return unless workshop_type_id_changed?
    return unless reservations.any? || seats.any?

    errors.add(:workshop_type_id, 'not allowed to be changed if reservations or seats exist')
  end
end
