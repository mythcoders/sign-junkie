# frozen_string_literal: true

def random_string
  SecureRandom.hex
end

def random_integer
  rand(1_000_000)
end

def create_and_login_user
  logout_user
  current_user = FactoryBot.create(:user)
  login_user current_user
  current_user
end

def login_user(user)
  @request.env["devise.mapping"] = Devise.mappings[:user]
  sign_in user
end

def logout_user
  sign_out :user
end
