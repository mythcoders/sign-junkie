# frozen_string_literal: true

unless User.where(email: SystemInfo.support_key).any?
  User.create(first_name: 'MythCoders',
              last_name: 'Support',
              role: 'operator',
              email: SystemInfo.support_key,
              password: SystemInfo.support_secret,
              confirmed_at: DateTime.now)
end

TaxRate.create!(rate: BigDecimal('0.0725'), effective_date: DateTime.now) unless TaxRate.all.any?

if Rails.env.development?
  def new_user(role)
    User.create(first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name,
                email: Faker::Internet.safe_email,
                password: 'test1234',
                confirmed_at: DateTime.now,
                role: role)
  end

  new_user('admin')
  3.times { new_user('customer') }
end
