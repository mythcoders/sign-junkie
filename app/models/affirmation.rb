# frozen_string_literal: true

class Affirmation < ApplicationRecord
  belongs_to :workshop_type
  has_rich_text :content
  validates :title, presence: true
  validates :workshop_type_id, presence: true
end
