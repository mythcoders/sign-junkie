# frozen_string_literal: true

FactoryBot.define do
  factory :stencil do
    name { Faker::Lorem.word }
    category { stencil_category }
  end
end
