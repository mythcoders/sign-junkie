# frozen_string_literal: true

class TaxRate < ApplicationRecord
  has_paper_trail

  validates_presence_of :rate, :effective_date
  validates :rate, numericality: {greater_than: 0}

  def self.current
    TaxRate.where("effective_date <= CURRENT_TIMESTAMP")
      .order(effective_date: :desc)
      .first
  end

  def self.enabled?
    TaxRate.current&.rate&.positive? || false
  end

  def editable?
    effective_date.future?
  end

  def display
    @display ||= rate.present? ? rate * 100 : 0
  end
end
