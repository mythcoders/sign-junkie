# frozen_string_literal: true

module Nameable
  extend ActiveSupport::Concern

  included do
    scope :first_name_start, ->(value) { where('first_name LIKE :prefix', prefix: "#{value}%") }
    scope :last_name_start, ->(value) { where('last_name LIKE :prefix', prefix: "#{value}%") }

    validates_presence_of :first_name, :last_name
    validates_length_of :first_name, :last_name, maximum: 50
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    full_name.split.map(&:first).join
  end
end
