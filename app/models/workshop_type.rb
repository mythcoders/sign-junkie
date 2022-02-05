# frozen_string_literal: true

class WorkshopType < ApplicationRecord
  has_paper_trail
  has_many :affirmations
  has_many :workshops

  belongs_to :guest_policy, class_name: "Policy", optional: true
  belongs_to :host_policy, class_name: "Policy", optional: true

  class << self
    def to_dropdown
      all.map { |i| [i.name, i.id] }
    end
  end
end
