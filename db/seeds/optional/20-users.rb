# frozen_string_literal: true

puts "Creating users..."

def new_user(role, email = Faker::Internet.safe_email, first_name = Faker::Name.first_name, last_name = Faker::Name.last_name)
  return if User.where(email: email).any?

  User.create!(first_name: first_name,
    last_name: last_name,
    email: email,
    password: "test1234",
    confirmed_at: Time.zone.now,
    role: role)
end

unless User.where(email: SystemInfo.support_key).any?
  User.create(first_name: "MythCoders",
    last_name: "Support",
    role: "operator",
    email: SystemInfo.support_key,
    password: SystemInfo.support_secret,
    confirmed_at: Time.zone.now)
end

new_user("admin", ClientInfo.admin_email, "Martha", "Rusler")

5.times do
  new_user("customer")
end
