# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "#{ClientInfo.name} <notifications@#{ClientInfo.domain}>"
  default reply_to: "Martha Rusler <#{ClientInfo.admin_email}>"
  layout 'mailer'
end
