# frozen_string_literal: true

class UserMailer < Devise::Mailer
  layout "mailer"
  default from: "#{ClientInfo.name} <notifications@#{ClientInfo.domain}>"
  default reply_to: "Martha Rusler <#{ClientInfo.admin_email}>"
  default template_path: "devise/mailer"

  def confirmation_instructions(record, token, opts = {})
    super
  end

  def reset_password_instructions(record, token, opts = {})
    super
  end

  def unlock_instructions(record, token, opts = {})
    super
  end

  def email_changed(record, opts = {})
    super
  end

  def password_change(record, opts = {})
    super
  end

  def invitation_instructions(record, token, opts = {})
    super
  end
end
