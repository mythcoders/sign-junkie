# frozen_string_literal: true

class UserMailer < Devise::Mailer
  layout 'mailer'
  default from: "#{ClientInfo.name} <#{ClientInfo.contact_email}>"
  default template_path: 'devise/mailer'

  def confirmation_instructions(record, token, opts = {})
    bootstrap = BootstrapEmail::Compiler.new(super)
    bootstrap.perform_full_compile
  end

  def reset_password_instructions(record, token, opts = {})
    bootstrap = BootstrapEmail::Compiler.new(super)
    bootstrap.perform_full_compile
  end

  def unlock_instructions(record, token, opts = {})
    bootstrap = BootstrapEmail::Compiler.new(super)
    bootstrap.perform_full_compile
  end

  def email_changed(record, opts = {})
    bootstrap = BootstrapEmail::Compiler.new(super)
    bootstrap.perform_full_compile
  end

  def password_change(record, opts = {})
    bootstrap = BootstrapEmail::Compiler.new(super)
    bootstrap.perform_full_compile
  end

  def invitation_instructions(record, token, opts = {})
    bootstrap = BootstrapEmail::Compiler.new(super)
    bootstrap.perform_full_compile
  end
end
