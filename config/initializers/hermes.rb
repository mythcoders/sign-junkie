ActionMailer::Base.add_delivery_method :hermes,
                                       Hermes::Mailbox,
                                       environment: Rails.env
