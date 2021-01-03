# frozen_string_literal: true

FactoryBot.define do
  factory :workshop do
    name { Faker::Lorem.sentence(word_count: 3) }
    workshop_type

    trait :for_sale do
      is_for_sale { true }
      purchase_start_date { purchase_end_date - 5.days }
      start_date { Faker::Date.forward(days: 31) }
      purchase_end_date { start_date - 2.days }
      end_date { start_date + 3.hours }
    end

    trait :private do
    end

    trait :not_for_sale do
      is_for_sale { false }
    end

    trait :with_projects do
      after(:create) do |workshop|
        create_list :workshop_project, 1, workshop: workshop, project: create(:project, :with_stencils, :with_addons)
      end
    end

    trait :with_projects_and_stencils do
      after(:create) do |workshop|
        create_list :workshop_project, 3, workshop: workshop
      end
    end

    factory :bookable_workshop, traits: %i[for_sale with_projects]
  end
end
