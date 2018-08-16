# frozen_string_literal: true

class Event < ApplicationRecord
  audited
  has_many_attached :images

  validates_presence_of :name, :posting_start_date, :start_date, :is_for_sale
  # validates_length_of :description

  def primary_image_attachment_id
    primary_image.id
  end

  def primary_image
    images.order(:id).first if images.any?
  end

end
