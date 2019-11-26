# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  EMAIL_FORMAT = /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i.freeze

  def validate_each(record, attribute, value)
    if value =~ EMAIL_FORMAT
      # record.errors[attribute] << domain_error_message unless valid_domain(value)
    else
      record.errors[attribute] << format_error_message
    end
  rescue Resolv::ResolvError, Resolv::ResolvTimeout
    record.errors[attribute] << domain_error_message
  end

  private

  def valid_domain(value)
    Resolv::DNS.new.getresources(value.split('@').last, Resolv::DNS::Resource::IN::MX).any?
  end

  def format_error_message
    options[:message] || I18n.t('errors.messages.email')
  end

  def domain_error_message
    options[:message] || 'does not have a valid domain'
  end
end
