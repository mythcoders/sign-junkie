# frozen_string_literal: true

class TaxPeriod < ApplicationRecord
  has_paper_trail

  validates_presence_of :start_date, :due_date, :amount_paid

  def name
    case start_date.month
    when 1..6
      "#{start_date.year} H1"
    when 7..12
      "#{start_date.year} H2"
    end
  end
end
