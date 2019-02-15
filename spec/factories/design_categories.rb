FactoryBot.define do
  factory :design_category do
    name { Faker::Lorem.word }

    trait :with_parent do
      parent_category { design_category }
    end
  end
end
