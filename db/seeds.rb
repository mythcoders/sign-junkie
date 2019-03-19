unless User.where(email: SystemInfo.support_key).any?
  User.create(first_name: 'MythCoders',
              last_name: 'Support',
              role: 'operator',
              email: SystemInfo.support_key,
              password: SystemInfo.support_secret,
              confirmed_at: DateTime.now)
end

def new_category
  StencilCategory.create!(name: Faker::StarWars.call_squadron)
end

@categories = [new_category, new_category]

def new_stencil
  Stencil.create!(name: Faker::StarWars.droid, category: @categories.sample)
end

def new_user(role)
  User.create(first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.safe_email,
              password: 'test1234',
              confirmed_at: DateTime.now,
              role: role)
end

if Rails.env.development? || ENV['DB_GEN']
  3.times do
    new_user('customer')
  end

  new_user('admin')

  if Project.all.count < 15
    15.times do
      Project.create!(name: Faker::StarWars.vehicle,
                      description: Faker::StarWars.wookiee_sentence,
                      stencils: [new_stencil, new_stencil])
    end
  end
end
