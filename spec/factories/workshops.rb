FactoryBot.define do
  factory :workshop do
    name { Faker::Lorem.sentence(3) }
    is_public { true }

    trait :for_sale do
      is_for_sale { true }
      purchase_end_date { Date.today }
      purchase_start_date { purchase_end_date - 5.days }
      start_date { Faker::Date.forward(23) }
      end_date { start_date + 3.hours }
      total_tickets { Faker::Number.between(Workshop.private_min, Workshop.private_max) }
    end

    trait :private do
      is_public { false }
      total_tickets { Faker::Number.between(Workshop.private_min, Workshop.private_max) }
      reservation_price { Workshop.private_deposit }
    end

    trait :not_for_sale do
      is_for_sale { false }
    end

    trait :with_projects do
      after(:create) do |workshop|
        create_list :workshop_project, 3, workshop: workshop
      end
    end
  end
end
