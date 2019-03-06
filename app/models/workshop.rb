class Workshop < ApplicationRecord
  has_many :projects
  has_many :seats
end
