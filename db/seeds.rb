# frozen_string_literal: true

require 'open-uri'

unless User.where(email: SystemInfo.support_key).any?
  User.create(first_name: 'MythCoders',
              last_name: 'Support',
              role: 'operator',
              email: SystemInfo.support_key,
              password: SystemInfo.support_secret,
              confirmed_at: DateTime.now)
end

TaxRate.create!(rate: BigDecimal('0.0725'), effective_date: DateTime.now) unless TaxRate.all.any?

if Rails.env.development? || ENV['DB_SEED']
  def new_user(role)
    User.create(first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name,
                email: Faker::Internet.safe_email,
                password: 'test1234',
                confirmed_at: DateTime.now,
                role: role)
  end

  def image_fetcher
    open(Faker::Avatar.image)
  rescue
    open("https://robohash.org/#{Faker::Lorem.characters(10)}.png?size=300x300&set=set4")
  end

  def image
    {
      io: image_fetcher,
      filename: "#{Faker::Lorem.characters(8)}_faker_image.jpg"
    }
  end

  new_user('admin')
  new_user('customer')

  2.times do
    StencilCategory.create!(name: Faker::Lorem.characters(10))
    stencil = Stencil.create!(name: Faker::Lorem.characters(10),
                              category: StencilCategory.all.sample)
    stencil.image.attach(image)

    addon = Addon.create!(name: "#{Faker::Construction.material} #{Faker::Lorem.characters(5)}",
                          price: Faker::Number.decimal(2))
    addon.addon_images.attach([image, image])

    project = Project.create!(name: Faker::Lorem.characters(10),
                              material_price: Faker::Number.decimal(2),
                              instructional_price: Faker::Number.decimal(2),
                              addons: Addon.all.sample(2),
                              stencils: Stencil.all.sample(2))
    project.project_images.attach([image, image])
  end

  purchase_start_date = Time.zone.today - 2.days
  purchase_end_date = purchase_start_date + 4.days
  start_date = purchase_end_date + 2.days
  end_date = start_date + 3.hours

  public_workshop = Workshop.create!(name: "#{Faker::Lorem.characters(5)}",
                                     projects: Project.all.sample(2),
                                     purchase_start_date: purchase_start_date,
                                     purchase_end_date: purchase_end_date,
                                     start_date: start_date,
                                     end_date: end_date,
                                     total_tickets: Faker::Number.between(Workshop.private_min, Workshop.private_max),
                                     is_public: true,
                                     is_for_sale: true)
  public_workshop.workshop_images.attach([image, image])

  private_workshop = Workshop.create!(name: "#{Faker::Lorem.characters(5)}",
                                      projects: Project.all.sample(2),
                                      purchase_start_date: purchase_start_date,
                                      purchase_end_date: purchase_end_date,
                                      start_date: start_date,
                                      end_date: end_date,
                                      total_tickets: Faker::Number.between(Workshop.private_min, Workshop.private_max),
                                      reservation_price: Workshop.private_deposit,
                                      is_public: false,
                                      is_for_sale: true)
  private_workshop.workshop_images.attach([image, image])
end
