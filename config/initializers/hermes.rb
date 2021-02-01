# frozen_string_literal: true

ActionMailer::Base.add_delivery_method :hermes, Hermes::Mailbox, environment: ENV['GITLAB_ENVIRONMENT_NAME']
ActionMailer::Base.register_observer MailObserver
