# frozen_string_literal: true

FactoryBot.define do
  factory :stencil do
    name { Faker::Lorem.characters(10) }
    category { create(:stencil_category) }
  end
end
