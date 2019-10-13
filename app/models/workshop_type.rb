# frozen_string_literal: true

class WorkshopType < ApplicationRecord
  has_paper_trail
  has_many :workshops

  class << self
    def to_dropdown
      all.map { |i| [i.name, i.id] }
    end
  end
end
