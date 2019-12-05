# frozen_string_literal: true

class UnconfirmedAccountReminderWorker
  include Sidekiq::Worker

  # def perform
  #   unconfirmed_users.each(&:send_confirmation_instructions)
  # end

  def perform; end

  def unconfirmed_users
    User.customers
        .where('invitation_token IS NOT NULL')
        .where("date_trunc('day', invitation_sent_at + interval '72 hours') = date_trunc('day', ?::date)", Time.zone.now.today)
  end
end
