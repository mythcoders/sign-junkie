# frozen_string_literal: true

def random_string
  SecureRandom.hex
end

def random_integer
  rand(1_000_000)
end

def random_person
  {
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email
  }
end

def create_and_login_user
  sign_out :user
  current_user = create(:user)
  sign_in current_user
  current_user
end

def create_and_login_admin
  sign_out :user
  current_user = create(:admin)
  sign_in current_user
  current_user
end
