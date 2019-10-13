# frozen_string_literal: true

require 'open-uri'

unless User.where(email: SystemInfo.support_key).any?
  User.create(first_name: 'MythCoders',
              last_name: 'Support',
              role: 'operator',
              email: SystemInfo.support_key,
              password: SystemInfo.support_secret,
              confirmed_at: Time.zone.now)
end

unless WorkshopType.any?
  WorkshopType.create!(name: 'Public',
                       active: true,
                       default_single_seat_allow: true,
                       default_reservation_allow: true,
                       default_reservation_allow_multiple: true,
                       default_reservation_cancel_minimum_not_met: false,
                       default_reservation_allow_guest_cancel_seat: false,
                       default_total_seats: 18,
                       default_reservation_price: BigDecimal('50.00'),
                       default_reservation_minimum: 4,
                       default_reservation_maximum: 11)
  WorkshopType.create!(name: 'Private',
                       active: true,
                       default_single_seat_allow: false,
                       default_reservation_allow: true,
                       default_reservation_allow_multiple: false,
                       default_reservation_cancel_minimum_not_met: true,
                       default_reservation_allow_guest_cancel_seat: true,
                       default_total_seats: 18,
                       default_reservation_price: BigDecimal('100.00'),
                       default_reservation_minimum: 12,
                       default_reservation_maximum: 18)
end

TaxRate.create!(rate: BigDecimal('0.0725'), effective_date: Time.zone.now) unless TaxRate.all.any?

if Rails.env.development? || ENV['APOLLO_FULL_DB_SEED']
  def new_user(role, email = Faker::Internet.safe_email, first_name = Faker::Name.first_name, last_name = Faker::Name.last_name)
    return if User.where(email: email).any?

    User.create(first_name: first_name,
                last_name: last_name,
                email: email,
                password: 'test1234',
                confirmed_at: Time.zone.now,
                role: role)
  end

  def image_fetcher
    puts 'Fetching image...'
    open(Faker::Avatar.image)
  rescue
    open("https://robohash.org/#{Faker::Lorem.characters(10)}.png?size=300x300&set=set4")
  end

  def new_image
    {
      io: image_fetcher,
      filename: "#{Faker::Lorem.characters(8)}_faker_image.jpg"
    }
  end

  puts 'Creating users...'
  new_user('admin', ClientInfo.contact_email, 'Martha', 'Rusler')

  5.times do
    new_user('customer')
  end

  2.times do
    puts 'Creating stencils...'
    StencilCategory.create!(name: Faker::Lorem.characters(10))
    stencil = Stencil.create!(name: Faker::Lorem.characters(10),
                              category: StencilCategory.all.sample)
    stencil.image.attach(new_image)

    puts 'Creating addon...'
    addon = Addon.create!(name: "#{Faker::Construction.material} #{Faker::Lorem.characters(5)}",
                          price: Faker::Number.decimal(2))
    addon.addon_images.attach([new_image, new_image])

    puts 'Creating project...'
    project = Project.create!(name: Faker::Lorem.characters(10),
                              material_price: Faker::Number.decimal(2),
                              instructional_price: Faker::Number.decimal(2),
                              addons: Addon.all.sample(2),
                              stencils: Stencil.all.sample(2))
    project.project_images.attach([new_image, new_image])
  end

  purchase_start_date = Time.zone.today - 2.days
  purchase_end_date = purchase_start_date + 4.days
  start_date = purchase_end_date + 2.days
  end_date = start_date + 3.hours

  puts 'Creating workshops...'
  2.times do
    shop = Workshop.create!(name: "#{Faker::Lorem.characters(5)}",
                            projects: Project.all.sample(2),
                            purchase_start_date: purchase_start_date,
                            purchase_end_date: purchase_end_date,
                            start_date: start_date,
                            end_date: end_date,
                            workshop_type: WorkshopType.all.sample,
                            is_for_sale: true)
    shop.workshop_images.attach([new_image, new_image])
  end
end
