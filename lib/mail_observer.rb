# frozen_string_literal: true

class MailObserver
  def initialize(message)
    @message = message
  end

  def self.delivered_email(message)
    new(message).log_delivered_email
  end

  def log_delivered_email
    recipients.each do |recipient|
      user = User.where("email ILIKE ?", recipient).first
      next if user.nil?

      EmailLog.create!(
        user_id: user.id,
        subject: @message.subject
      )
    end
  end

  private

  def recipients
    @recipients ||= Array(@message.to) + Array(@message.bcc) + Array(@message.cc)
  end
end
