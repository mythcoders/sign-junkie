# frozen_string_literal: true

class CustomerMailerPreview < ActionMailer::Preview
  def gift_card
    CustomerMailer.with(gift_amount: 50.00, customer_id: User.first.id).gift_card
  end

  def abandoned_cart
    CustomerMailer.with(customer_id: User.first.id).abandoned_cart
  end
end
