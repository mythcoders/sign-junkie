# frozen_string_literal: true

FactoryBot.define do
  factory :item_description do
    transient do
      workshop { create(:bookable_workshop) }
    end

    identifier { SecureRandom.uuid }
    nontaxable_amount { 0.00 }
    taxable_amount { 0.00 }
    tax_rate { 0.00 }

    trait :voided do
      void_date { Time.zone.now }
    end

    trait :canceled do
      cancel_date { Time.zone.now }
    end

    factory :seat_item do
      transient do
        project { workshop.projects.first }
        stencil { project.stencils.first }
      end

      item_type { 'seat' }
      taxable_amount { project.material_price }
      nontaxable_amount { project.instructional_price }

      workshop_id { workshop.id }
      workshop_name { workshop.name }
      project_id { project.id }
      project_name { project.name }
      stencil_id { stencil.id }
      stencil_name { stencil.name }

      trait :with_addon do
        transient do
          addon { project.addons.first }
        end

        addon_id { addon.id }
        addon_name { addon.name }
      end

      factory :gifted_seat_item do
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        email { Faker::Internet.email }
      end
    end

    factory :reservation_item do
      item_type { 'reservation' }
      # fill in workshop info
      nontaxable_amount { Faker::Number.decimal(2) }
      payment_plan { 'host' }
    end

    factory :gift_card_item do
      item_type { 'gift_card' }
      nontaxable_amount { Faker::Number.decimal(2) }
      first_name { Faker::Name.first_name }
      last_name { Faker::Name.last_name }
      email { Faker::Internet.email }
    end
  end
end
