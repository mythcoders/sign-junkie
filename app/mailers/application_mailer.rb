# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "#{ClientInfo.name} <#{ClientInfo.contact_email}>"
  layout 'mailer'
end
