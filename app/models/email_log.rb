# frozen_string_literal: true

class EmailLog < ApplicationRecord
  belongs_to :user
  validates_presence_of :subject
end
