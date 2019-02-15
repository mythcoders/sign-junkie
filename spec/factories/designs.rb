FactoryBot.define do
  factory :design do
    name { Faker::Lorem.word }
    design_category
  end
end
