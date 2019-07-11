# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: [:customer] do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    confirmed_at { Date.today }
    role { 'customer' }

    factory :employee do
      role { 'employee' }
    end

    factory :admin do
      role { 'admin' }
    end

    factory :operator do
      role { 'operator' }
    end
  end
end
