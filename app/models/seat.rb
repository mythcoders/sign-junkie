# frozen_string_literal: true

class Seat < ApplicationRecord
  has_paper_trail
  belongs_to :reservation, optional: true
  belongs_to :customer, class_name: "User", foreign_key: "user_id"
  belongs_to :workshop
  belongs_to :description, class_name: "ItemDescription", foreign_key: "item_description_id", dependent: :destroy

  scope :for_user, ->(user) { where(user_id: user.id).order(created_at: :desc) unless user.nil? }
  scope :for_shop, ->(id) { where(workshop_id: id) }
  scope :not_gifted, -> { includes(:description).where(item_descriptions: {gifted: false}) }
  scope :active, lambda {
    includes(:description).where(item_descriptions: {cancel_date: nil, void_date: nil, refund_date: nil})
  }

  delegate_missing_to :description
  accepts_nested_attributes_for :description
  validates_presence_of :user_id
  validates_uniqueness_of :user_id, scope: %i[workshop_id item_description_id]

  def name
    if owner.first_name.present?
      "#{owner.first_name} #{owner.last_name}"
    # elsif customer.nil?
    #   'Unassigned'
    else
      customer.full_name
    end
  end

  def name_initials
    name.split.map(&:first).join.upcase
  end

  def showable?(user)
    return true if user.id == customer.id
    return true if reservation&.host?(user)

    false
  end

  def editable?(user)
    return false if invoice.present?
    return false if reservation.workshop.registration_deadline.past?
    return false if user.id != customer.id

    true
  end

  def reassignable?(user)
    return true if reservation.host?(user)
    return false unless editable?(user)

    true
  end
end
