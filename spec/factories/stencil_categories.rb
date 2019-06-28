# frozen_string_literal: true

FactoryBot.define do
  factory :stencil_category do
    name { Faker::Lorem.word }
  end
end
