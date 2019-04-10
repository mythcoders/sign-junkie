unless User.where(email: SystemInfo.support_key).any?
  User.create(first_name: 'MythCoders',
              last_name: 'Support',
              role: 'operator',
              email: SystemInfo.support_key,
              password: SystemInfo.support_secret,
              confirmed_at: DateTime.now)
end

def new_user(role)
  User.create(first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              email: Faker::Internet.safe_email,
              password: 'test1234',
              confirmed_at: DateTime.now,
              role: role)
end

if Rails.env.development?
  3.times do
    new_user('customer')
  end

  new_user('admin')
end

if ENV['DB_GEN']
  addon_wreath = Addon.create!(name: 'Wreath', price: 10.00)
  addon_edge = Addon.create!(name: 'Decorative Edge', price: 5.00)

  Project.create!(name: "Standard Signs - Planked 14.5\" x 18\"", material_price: 7.45, instructional_price: 37.55)
  Project.create!(name: "Standard Signs - Planked 16.5\" x 22\"", material_price: 9.45, instructional_price: 40.55)
  p1 = Project.create!(name: "Standard Signs - Planked 16.5\" x 27\"", material_price: 10.50, instructional_price: 39.50)
  Project.create!(name: "Long Signs - Planked 11\" x 30\"", material_price: 9.00, instructional_price: 41.00)
  Project.create!(name: "Long Signs - Planked 11\" x 36\"", material_price: 10.45, instructional_price: 44.55)
  Project.create!(name: "Long Signs - Planked 7\" x 60\"", material_price: 7.50, instructional_price: 52.50)
  Project.create!(name: "Long Signs - Flat 7\" x 36\"", material_price: 5.85, instructional_price: 35.15)
  Project.create!(name: "Long Signs - Flat 9\" x 32\"", material_price: 6.40, instructional_price: 38.60)
  p2 = Project.create!(name: "Long Signs - Flat 9\" x 48\"", material_price: 6.00, instructional_price: 44.00)

  Project.all.each do |project|
    ProjectAddon.create!(project: project, addon: addon_edge)
  end

  ProjectAddon.create!(project: p1, addon: addon_wreath)
  ProjectAddon.create!(project: p2, addon: addon_wreath)
end
