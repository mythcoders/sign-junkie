# frozen_string_literal: true

class CustomerService < ApplicationService
  def self.find_or_invite(first_name, last_name, email)
    recipient = User.find_by_email(email)
    if recipient.nil?
      recipient = User.invite!(email: email,
                               first_name: first_name,
                               last_name: last_name,
                               role: 'customer')
    end

    recipient
  end

  def self.find_or_invite_recipient(item)
    if item.recipient.nil?
      item.recipient = User.invite!(email: item.email,
                                    first_name: item.first_name,
                                    last_name: item.last_name,
                                    role: 'customer')
    end

    item.recipient
  end

  def issue_gift_card(item, _purchaser)
    recipient = CustomerService.find_or_invite(item.first_name, item.last_name, item.email)
    recipient.credits << CustomerCredit.new(starting_amount: item.item_amount,
                                            balance: item.item_amount)
    recipient.save!
  end
end
