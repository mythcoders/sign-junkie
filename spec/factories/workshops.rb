FactoryBot.define do
  factory :workshop do
    name { Faker::Lorem.sentence(3) }
    is_public { true }

    trait :for_sale do
      is_for_sale { true }
      purchase_start_date { Faker::Date.between(2.days.ago, Date.today) }
      purchase_end_date { Date.today }
      start_date { Date.today }
      end_date { Date.today }
      total_tickets { 1 }
    end

    trait :private do
      is_public { false }
      reservation_price { Faker::Number.decimal(2) }
    end

    trait :not_for_sale do
      is_for_sale { false }
    end
  end
end
