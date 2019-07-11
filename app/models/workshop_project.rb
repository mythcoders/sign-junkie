# frozen_string_literal: true

class WorkshopProject < ApplicationRecord
  belongs_to :project
  belongs_to :workshop
end
