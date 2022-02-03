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

  def devise_mail(record, action, opts = {}, &block)
    initialize_from_record(record)
    make_bootstrap_mail headers_for(action, opts), &block
  end
end
