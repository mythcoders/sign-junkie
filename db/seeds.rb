unless User.where(email: SystemInfo.support_key).any?
  User.create(first_name: 'MythCoders',
              last_name: 'Support',
              role: 'operator',
              email: SystemInfo.support_key,
              password: SystemInfo.support_secret,
              confirmed_at: DateTime.now)
end

if Rails.env.development? || ENV['DB_GEN']
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
end
