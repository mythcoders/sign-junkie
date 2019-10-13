# frozen_string_literal: true

class CustomerMailerPreview < ActionMailer::Preview
  def gift_card
    CustomerMailer.with(gift_amount: 50.00, customer: User.find(1)).gift_card
  end
end
