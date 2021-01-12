# frozen_string_literal: true

ActionMailer::Base.add_delivery_method :hermes, Hermes::Mailbox, environment: Rails.env
ActionMailer::Base.register_observer MailObserver
