# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    customer
    status { 'draft' }
    due_date { Date.today }
  end
end
