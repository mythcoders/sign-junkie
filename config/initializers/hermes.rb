# frozen_string_literal: true

require "mail_observer"

ActionMailer::Base.add_delivery_method :hermes, Hermes::Mailbox, environment: ENV["ENVIRONMENT_NAME"]
ActionMailer::Base.register_observer MailObserver
