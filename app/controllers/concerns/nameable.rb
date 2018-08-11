# frozen_string_literal: true

module Nameable
  extend ActiveSupport::Concern

  included do
    scope :first_name_start, ->(value) { where('first_name LIKE :prefix', prefix: "#{value}%") }
    scope :last_name_start, ->(value) { where('last_name LIKE :prefix', prefix: "#{value}%") }

    validates_presence_of :first_name, :last_name
    validates_length_of :first_name, :last_name, maximum: 50
    validates_length_of :middle_name, maximum: 25
    validates_length_of :phone_number, maximum: 10
  end

  def full_name
    if middle_name.blank?
      "#{first_name} #{last_name}"
    else
      "#{first_name} #{middle_name}. #{last_name}"
    end
  end
end
