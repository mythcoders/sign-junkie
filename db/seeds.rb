unless User.where(email: Ares::SystemInfo.support_key).any?
  User.create(first_name: 'MythCoders',
              last_name: 'Support',
              role: 'operator',
              phone_number: '8336842377',
              email: Ares::SystemInfo.support_key,
              password: Ares::SystemInfo.support_secret,
              confirmed_at: DateTime.now)
end

if Rails.env.development? || ENV['DB_GEN']
  def new_addon
    Addon.new(name: Faker::StarWars.droid, price: Faker::Commerce.price(0..10.0, false))
  end

  if User.customers.count < 3
    3.times do
      User.create(first_name: Faker::Name.first_name,
                 last_name: Faker::Name.last_name,
                 role: 'customer',
                 email: Faker::Internet.safe_email,
                 password: 'test1234',
                 confirmed_at: DateTime.now)
    end
  end

  if Project.all.count < 5
    5.times do
      Project.create(name: Faker::StarWars.vehicle,
                     description: Faker::StarWars.wookiee_sentence,
                     addons: [ new_addon, new_addon ])
    end
  end

  # Active Now
  Workshop.create(name: Faker::StarWars.planet,
                  description: Faker::Lorem.paragraph,
                  posting_start_date: Faker::Time.between(8.days.ago, Date.today, :all),
                  posting_end_date: Faker::Time.between(3.days.since,  7.days.since, :all),
                  start_date: Faker::Time.between(8.days.since, 9.days.since, :afternoon),
                  end_date: Faker::Time.between(8.days.since, 9.days.since, :evening),
                  tickets_available: 25,
                  ticket_price: Faker::Commerce.price(10.0..50.0, false),
                  is_for_sale: true,
                  is_public: true)

  # Active Future
end
