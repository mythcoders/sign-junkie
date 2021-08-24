# frozen_string_literal: true

class UserMailerPreview < ActionMailer::Preview
  # tested
  def invitation_instructions
    UserMailer.invitation_instructions(User.first, "faketoken")
  end

  # tested
  def reset_password_instructions
    UserMailer.reset_password_instructions(User.first, "faketoken")
  end

  def email_changed
    UserMailer.email_changed(User.first)
  end

  def password_change
    UserMailer.password_change(User.first)
  end

  # ERROR!
  def unlock_instructions
    UserMailer.unlock_instructions(User.first, "faketoken")
  end

  # tested
  def confirmation_instructions
    UserMailer.confirmation_instructions(User.first, "faketoken")
  end
end
