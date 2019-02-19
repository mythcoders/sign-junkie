unless User.where(email: SystemInfo.support_key).any?
  User.create(first_name: 'MythCoders',
              last_name: 'Support',
              role: 'operator',
              phone_number: '8336842377',
              email: SystemInfo.support_key,
              password: SystemInfo.support_secret,
              confirmed_at: DateTime.now)
end

if Rails.env.development? || ENV['DB_GEN']
  @categories = [Faker::StarWars.call_squadron, Faker::StarWars.call_squadron]

  def build_addons
    items = Faker::Number.between(1, 5)
    Array.new(items, new_addon)
  end

  def new_addon
    Addon.new(name: Faker::StarWars.droid,
              price: Faker::Commerce.price(0..10.0, false))
  end

  def build_project_workshops
    items = Faker::Number.between(1, 5)
    Array.new(items, new_project_workshop)
  end

  def new_project_workshop
    ProjectWorkshop.new(project: Project.all.sample)
  end

  def new_category
    DesignCategory.create!(name: Faker::StarWars.call_squadron)
  end

  def new_design
    Design.create!(name: Faker::StarWars.call_number, category: @categories.sample)
  end

  def build_designs
    items = Faker::Number.between(1, 5)
    Array.new(items, new_design)
  end

  def new_user(role)
    User.create(first_name: Faker::Name.first_name,
               last_name: Faker::Name.last_name,
               email: Faker::Internet.safe_email,
               password: 'test1234',
               confirmed_at: DateTime.now,
               role: role)
  end

  3.times do
    new_user('customer')
  end

  new_user('admin')

  #10.times do
  #  new_design
  #end

  if Project.all.count < 15
    15.times do
      Project.create!(name: Faker::StarWars.vehicle,
                     description: Faker::StarWars.wookiee_sentence,
                     addons: build_addons)
    end
  end

  10.times do
    # Active Now
    Workshop.create!(name: Faker::StarWars.planet,
                     description: Faker::Lorem.paragraph,
                     purchase_start_date: Faker::Time.between(8.days.ago, Date.today, :all),
                     purchase_end_date: Faker::Time.between(3.days.since,  7.days.since, :all),
                     start_date: Faker::Time.between(8.days.since, 9.days.since, :afternoon),
                     end_date: Faker::Time.between(8.days.since, 9.days.since, :evening),
                     total_tickets: Faker::Number.between(12, 30),
                     ticket_price: Faker::Commerce.price(10.0..50.0, false),
                     is_for_sale: true,
                     is_public: Faker::Boolean.boolean,
                     project_workshops: build_project_workshops)
  end
end
