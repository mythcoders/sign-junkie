# frozen_string_literal: true

class Announcement < ApplicationRecord
  validates_presence_of :start_at, if: :end_at
  has_rich_text :content

  scope :active, -> { where('start_at <= current_timestamp and (end_at is null or end_at >= current_timestamp)') }

  def active?
    start_at&.past? && (end_at.nil? || end_at.future?)
  end
end
