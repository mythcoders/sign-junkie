# frozen_string_literal: true

class UnconfirmedAccountReminderWorker
  include Sidekiq::Worker

  def perform
    unconfirmed_signups.each do |user|
      Devise::Mailer.confirmation_instructions(user).deliver_later
    end

    unconfirmed_invitations.each(&:deliver_invitation)
  end

  private

  def unconfirmed_signups(as_of = Time.zone.today)
    User.customers
      .where("confirmation_token IS NOT NULL")
      .where("date_trunc('day', confirmation_sent_at + interval '48 hours') = date_trunc('day', ?::date)", as_of)
  end

  def unconfirmed_invitations(as_of = Time.zone.today)
    User.customers
      .where("invitation_token IS NOT NULL")
      .where("date_trunc('day', invitation_sent_at + interval '72 hours') = date_trunc('day', ?::date)", as_of)
  end
end
