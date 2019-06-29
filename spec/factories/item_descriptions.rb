# frozen_string_literal: true

FactoryBot.define do
  factory :item_description do
    transient do
      workshop { create(:workshop, :with_projects) }
    end

    identifier { SecureRandom.uuid }
    taxable_amount { 0.00 }
    tax_rate { 0.00 }

    trait :voided do
      void_date { DateTime.now }
    end

    trait :canceled do
      cancel_date { DateTime.now }
    end

    factory :seat_item do
      transient do
        project { workshop.projects.random }
        stencil { project.stencils.random }
      end

      item_type { :seat }
      taxable_amount { 0.00 }
      nontaxable_amount { Faker::Number.decimal(2) }
      tax_rate { 0.00 }

      workshop_id { workshop.id }
      workshop_name { workshop.name }
      project_id { project.id }
      project_name { project.name }
      stencil_id { stencil.id }
      stencil_name { stencil.name }

      trait :with_addon do
        transient do
          addon { project.addons.random }
        end

        addon_id { addon.id }
        addon_name { addon.name }
      end

      factory :gifted_seat_item do
        first_name { Faker::Name::first_name }
        last_name { Faker::Name::last_name }
        email { Faker::Internet.email }
      end
    end

    factory :reservation_item do
      item_type { :reservation }
      nontaxable_amount { Faker::Number.decimal(2) }
      seats_booked { Faker::Number.between(1, 10) }
    end

    factory :gift_card_item do
      item_type { :gift_card }
      nontaxable_amount { Faker::Number.decimal(2) }
      first_name { Faker::Name::first_name }
      last_name { Faker::Name::last_name }
      email { Faker::Internet.email }
    end
  end
end
