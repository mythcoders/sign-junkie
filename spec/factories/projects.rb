FactoryBot.define do
  factory :project do
    name { Faker::Lorem.word }
    instructional_price { Faker::Number.decimal(2) }
    material_price { Faker::Number.decimal(2) }

    trait :with_addons do
      after(:create) do |project|
        create_list :project_addon, 2, project: project
      end
    end
  end
end
